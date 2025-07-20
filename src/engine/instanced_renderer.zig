const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});
const Shader = @import("shader.zig").Shader;
const AssetBundle = @import("asset_bundle.zig").AssetBundle;
const Transform = @import("transform.zig").Transform;
const SpriteRenderer = @import("sprite_renderer.zig").SpriteRenderer;
const math = @import("math.zig");
const Camera = @import("camera.zig").Camera;

const MAX_INSTANCES = 10000;

pub const InstancedRenderer = struct {
    shader: Shader,
    asset_bundle: *AssetBundle,
    VAO: c_uint,
    VBO: c_uint, // Vertex buffer for quad geometry
    instance_VBO: c_uint, // Instance buffer for transform matrices
    EBO: c_uint,
    allocator: std.mem.Allocator,

    // Performance counters
    draw_calls: u32,
    instances_rendered: u32,

    pub fn init(allocator: std.mem.Allocator, asset_bundle: *AssetBundle) !InstancedRenderer {
        // Instanced vertex shader
        const vertex_source = 
            \\#version 330 core
            \\layout (location = 0) in vec3 aPos;
            \\layout (location = 1) in vec2 aTexCoord;
            \\
            \\// Instance data (per sprite transform matrix)
            \\layout (location = 2) in mat4 aInstanceMatrix;
            \\
            \\uniform mat4 viewMatrix;
            \\
            \\out vec2 TexCoord;
            \\
            \\void main()
            \\{
            \\    gl_Position = viewMatrix * aInstanceMatrix * vec4(aPos, 1.0);
            \\    TexCoord = aTexCoord;
            \\}
        ;

        const fragment_source = 
            \\#version 330 core
            \\out vec4 FragColor;
            \\
            \\in vec2 TexCoord;
            \\uniform sampler2D ourTexture;
            \\
            \\void main()
            \\{
            \\    FragColor = texture(ourTexture, TexCoord);
            \\}
        ;

        const shader = try Shader.init(vertex_source, fragment_source);

        var VAO: c_uint = undefined;
        var VBO: c_uint = undefined;
        var instance_VBO: c_uint = undefined;
        var EBO: c_uint = undefined;

        c.glGenVertexArrays(1, &VAO);
        c.glGenBuffers(1, &VBO);
        c.glGenBuffers(1, &instance_VBO);
        c.glGenBuffers(1, &EBO);

        c.glBindVertexArray(VAO);

        // Create unit quad geometry (uploaded once)
        const vertices = [_]f32{
            // Positions   // Texture Coords (corrected orientation)
             0.5,  0.5, 0.0,   1.0, 0.0,  // top right
             0.5, -0.5, 0.0,   1.0, 1.0,  // bottom right
            -0.5, -0.5, 0.0,   0.0, 1.0,  // bottom left
            -0.5,  0.5, 0.0,   0.0, 0.0   // top left
        };

        const indices = [_]c_uint{
            0, 1, 3,  // first triangle
            1, 2, 3   // second triangle
        };

        // Upload quad geometry
        c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
        c.glBufferData(c.GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, c.GL_STATIC_DRAW);

        // Upload indices
        c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, EBO);
        c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, indices.len * @sizeOf(c_uint), &indices, c.GL_STATIC_DRAW);

        // Vertex attributes for quad geometry
        c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), null);
        c.glEnableVertexAttribArray(0);
        c.glVertexAttribPointer(1, 2, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), @ptrFromInt(3 * @sizeOf(f32)));
        c.glEnableVertexAttribArray(1);

        // Setup instance buffer for transform matrices
        c.glBindBuffer(c.GL_ARRAY_BUFFER, instance_VBO);
        c.glBufferData(c.GL_ARRAY_BUFFER, MAX_INSTANCES * 16 * @sizeOf(f32), null, c.GL_DYNAMIC_DRAW);

        // Instance matrix attributes (mat4 takes 4 attribute slots)
        for (0..4) |i| {
            c.glVertexAttribPointer(@intCast(2 + i), 4, c.GL_FLOAT, c.GL_FALSE, 16 * @sizeOf(f32), @ptrFromInt(i * 4 * @sizeOf(f32)));
            c.glEnableVertexAttribArray(@intCast(2 + i));
            c.glVertexAttribDivisor(@intCast(2 + i), 1); // Instance attribute
        }

        c.glBindBuffer(c.GL_ARRAY_BUFFER, 0);
        c.glBindVertexArray(0);

        return InstancedRenderer{
            .shader = shader,
            .asset_bundle = asset_bundle,
            .VAO = VAO,
            .VBO = VBO,
            .instance_VBO = instance_VBO,
            .EBO = EBO,
            .allocator = allocator,
            .draw_calls = 0,
            .instances_rendered = 0,
        };
    }

    pub fn render(self: *InstancedRenderer, transforms: []const Transform, sprite_renderers: []const SpriteRenderer, camera: *const Camera) !void {
        if (transforms.len != sprite_renderers.len) {
            return error.MismatchedArrayLengths;
        }

        self.draw_calls = 0;
        self.instances_rendered = 0;

        // Group sprites by texture for batching
        var texture_batches = std.ArrayList(struct {
            texture_name: []const u8,
            instances: std.ArrayList([16]f32), // Transform matrices
        }).init(self.allocator);
        defer {
            for (texture_batches.items) |*batch| {
                batch.instances.deinit();
            }
            texture_batches.deinit();
        }

        // Build batches
        for (transforms, sprite_renderers) |transform, sprite_renderer| {
            if (!sprite_renderer.visible) continue;

            // Find or create batch for this texture
            var batch_index: ?usize = null;
            for (texture_batches.items, 0..) |*batch, i| {
                if (std.mem.eql(u8, batch.texture_name, sprite_renderer.sprite_name)) {
                    batch_index = i;
                    break;
                }
            }

            if (batch_index == null) {
                try texture_batches.append(.{
                    .texture_name = sprite_renderer.sprite_name,
                    .instances = std.ArrayList([16]f32).init(self.allocator),
                });
                batch_index = texture_batches.items.len - 1;
            }

            // Create transform matrix for this instance
            const transform_matrix = createTransformMatrix(transform);
            try texture_batches.items[batch_index.?].instances.append(transform_matrix);
        }

        // Render each batch
        self.shader.use();
        self.shader.setInt("ourTexture", 0);

        // Update camera
        var updated_camera = camera.*;
        var viewport: [4]c_int = undefined;
        c.glGetIntegerv(c.GL_VIEWPORT, &viewport);
        const width = @as(f32, @floatFromInt(viewport[2]));
        const height = @as(f32, @floatFromInt(viewport[3]));
        updated_camera.setAspectRatio(width / height);

        const view_matrix = updated_camera.getViewMatrix();
        self.shader.setMat4("viewMatrix", &view_matrix);

        c.glBindVertexArray(self.VAO);

        for (texture_batches.items) |*batch| {
            if (batch.instances.items.len == 0) continue;

            // Bind texture
            if (self.asset_bundle.getTexture(batch.texture_name)) |texture| {
                texture.bind();

                // Upload instance data
                c.glBindBuffer(c.GL_ARRAY_BUFFER, self.instance_VBO);
                c.glBufferSubData(
                    c.GL_ARRAY_BUFFER, 
                    0, 
                    @intCast(batch.instances.items.len * 16 * @sizeOf(f32)), 
                    batch.instances.items.ptr
                );

                // Draw all instances in one call
                c.glDrawElementsInstanced(c.GL_TRIANGLES, 6, c.GL_UNSIGNED_INT, null, @intCast(batch.instances.items.len));

                self.draw_calls += 1;
                self.instances_rendered += @intCast(batch.instances.items.len);
            }
        }

        c.glBindVertexArray(0);
    }

    pub fn getPerformanceStats(self: *InstancedRenderer) struct { draw_calls: u32, instances_rendered: u32 } {
        return .{ .draw_calls = self.draw_calls, .instances_rendered = self.instances_rendered };
    }

    pub fn deinit(self: *InstancedRenderer) void {
        c.glDeleteVertexArrays(1, &self.VAO);
        c.glDeleteBuffers(1, &self.VBO);
        c.glDeleteBuffers(1, &self.instance_VBO);
        c.glDeleteBuffers(1, &self.EBO);
        self.shader.deinit();
    }
};

fn createTransformMatrix(transform: Transform) [16]f32 {
    const pos = transform.position.toFloat();
    const scale = transform.scale.toFloat();
    const rotation = transform.rotation;

    const cos_r = @cos(rotation);
    const sin_r = @sin(rotation);

    // Create 4x4 transformation matrix (column-major order for OpenGL)
    return [16]f32{
        scale.x * cos_r,  scale.x * sin_r,  0.0, 0.0,
        -scale.y * sin_r, scale.y * cos_r,  0.0, 0.0,
        0.0,              0.0,              1.0, 0.0,
        pos.x,            pos.y,            0.0, 1.0,
    };
}