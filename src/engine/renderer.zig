const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});
const Shader = @import("shader.zig").Shader;
const AssetBundle = @import("asset_bundle.zig").AssetBundle;
const Transform = @import("transform.zig").Transform;
const SpriteRenderer = @import("sprite_renderer.zig").SpriteRenderer;
const math = @import("math.zig");

const MAX_SPRITES = 1000;
const VERTICES_PER_SPRITE = 4;
const INDICES_PER_SPRITE = 6;

pub const Renderer = struct {
    shader: Shader,
    asset_bundle: *AssetBundle,
    VAO: c_uint,
    VBO: c_uint,
    EBO: c_uint,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, asset_bundle: *AssetBundle, vertex_source: []const u8, fragment_source: []const u8) !Renderer {
        const shader = try Shader.init(vertex_source, fragment_source);

        var VAO: c_uint = undefined;
        var VBO: c_uint = undefined;
        var EBO: c_uint = undefined;

        c.glGenVertexArrays(1, &VAO);
        c.glGenBuffers(1, &VBO);
        c.glGenBuffers(1, &EBO);

        c.glBindVertexArray(VAO);

        // Create buffer large enough for MAX_SPRITES
        c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
        c.glBufferData(c.GL_ARRAY_BUFFER, MAX_SPRITES * VERTICES_PER_SPRITE * 5 * @sizeOf(f32), null, c.GL_DYNAMIC_DRAW);

        // Create index buffer
        c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, EBO);
        var indices = try allocator.alloc(c_uint, MAX_SPRITES * INDICES_PER_SPRITE);
        defer allocator.free(indices);

        // Generate indices for all sprites
        for (0..MAX_SPRITES) |i| {
            const base_vertex = @as(c_uint, @intCast(i * VERTICES_PER_SPRITE));
            const base_index = i * INDICES_PER_SPRITE;
            
            indices[base_index + 0] = base_vertex + 0;
            indices[base_index + 1] = base_vertex + 1;
            indices[base_index + 2] = base_vertex + 3;
            indices[base_index + 3] = base_vertex + 1;
            indices[base_index + 4] = base_vertex + 2;
            indices[base_index + 5] = base_vertex + 3;
        }

        c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, @intCast(indices.len * @sizeOf(c_uint)), indices.ptr, c.GL_STATIC_DRAW);

        // Position attribute
        c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), null);
        c.glEnableVertexAttribArray(0);

        // Texture coordinate attribute
        c.glVertexAttribPointer(1, 2, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), @ptrFromInt(3 * @sizeOf(f32)));
        c.glEnableVertexAttribArray(1);

        c.glBindBuffer(c.GL_ARRAY_BUFFER, 0);
        c.glBindVertexArray(0);

        return Renderer{
            .shader = shader,
            .asset_bundle = asset_bundle,
            .VAO = VAO,
            .VBO = VBO,
            .EBO = EBO,
            .allocator = allocator,
        };
    }

    pub fn render(self: *Renderer, transforms: []const Transform, sprite_renderers: []const SpriteRenderer) !void {
        if (transforms.len != sprite_renderers.len) {
            return error.MismatchedArrayLengths;
        }

        var vertices = try self.allocator.alloc(f32, transforms.len * VERTICES_PER_SPRITE * 5);
        defer self.allocator.free(vertices);

        var sprite_count: usize = 0;
        var current_texture_name: ?[]const u8 = null;
        for (transforms, sprite_renderers) |transform, sprite_renderer| {
            if (!sprite_renderer.visible) continue;

            const texture = self.asset_bundle.getTexture(sprite_renderer.sprite_name) orelse continue;
            
            // Bind texture if it's different from the current one
            if (current_texture_name == null or !std.mem.eql(u8, current_texture_name.?, sprite_renderer.sprite_name)) {
                texture.bind();
                current_texture_name = sprite_renderer.sprite_name;
            }
            
            // Calculate sprite quad vertices with rotation
            const half_width = 0.5 * transform.scale.toFloatX();
            const half_height = 0.5 * transform.scale.toFloatY();
            const pos = transform.position.toFloat();
            const rotation = transform.rotation;
            
            // Pre-calculate rotation values
            const cos_r = @cos(rotation);
            const sin_r = @sin(rotation);
            
            const base_index = sprite_count * VERTICES_PER_SPRITE * 5;
            
            // Define the four corners of the sprite (before rotation)
            const corners = [_][2]f32{
                .{ half_width, half_height },   // Top right
                .{ half_width, -half_height },  // Bottom right
                .{ -half_width, -half_height }, // Bottom left
                .{ -half_width, half_height },  // Top left
            };
            
            // UV coordinates for each corner (flipped vertically to correct image orientation)
            const uvs = [_][2]f32{
                .{ 1.0, 0.0 }, // Top right (was 1.0, 1.0)
                .{ 1.0, 1.0 }, // Bottom right (was 1.0, 0.0)
                .{ 0.0, 1.0 }, // Bottom left (was 0.0, 0.0)
                .{ 0.0, 0.0 }, // Top left (was 0.0, 1.0)
            };
            
            // Apply rotation and translation to each corner
            for (corners, uvs, 0..) |corner, uv, i| {
                const vertex_index = base_index + i * 5;
                
                // Rotate the corner around the origin (negated rotation to match movement)
                const rotated_x = corner[0] * cos_r + corner[1] * sin_r;
                const rotated_y = -corner[0] * sin_r + corner[1] * cos_r;
                
                // Translate to final position
                vertices[vertex_index + 0] = pos.x + rotated_x;
                vertices[vertex_index + 1] = pos.y + rotated_y;
                vertices[vertex_index + 2] = 0.0;
                vertices[vertex_index + 3] = uv[0];
                vertices[vertex_index + 4] = uv[1];
            }
            
            sprite_count += 1;
        }

        if (sprite_count == 0) return;

        // Upload vertex data
        c.glBindBuffer(c.GL_ARRAY_BUFFER, self.VBO);
        c.glBufferSubData(c.GL_ARRAY_BUFFER, 0, @intCast(sprite_count * VERTICES_PER_SPRITE * 5 * @sizeOf(f32)), vertices.ptr);

        // Render each sprite individually with its own texture
        self.shader.use();
        self.shader.setInt("ourTexture", 0);
        
        // Get viewport dimensions and calculate aspect ratio
        var viewport: [4]c_int = undefined;
        c.glGetIntegerv(c.GL_VIEWPORT, &viewport);
        const width = @as(f32, @floatFromInt(viewport[2]));
        const height = @as(f32, @floatFromInt(viewport[3]));
        const aspect_ratio = width / height;
        self.shader.setFloat("aspectRatio", aspect_ratio);

        c.glBindVertexArray(self.VAO);
        
        // Render each sprite separately to handle different textures
        var rendered_sprites: usize = 0;
        for (sprite_renderers) |sprite_renderer| {
            if (!sprite_renderer.visible) continue;
            
            if (self.asset_bundle.getTexture(sprite_renderer.sprite_name)) |texture| {
                texture.bind();
                
                // Upload this sprite's vertex data
                const sprite_vertex_data = vertices[rendered_sprites * VERTICES_PER_SPRITE * 5..(rendered_sprites + 1) * VERTICES_PER_SPRITE * 5];
                c.glBufferSubData(c.GL_ARRAY_BUFFER, 0, @intCast(sprite_vertex_data.len * @sizeOf(f32)), sprite_vertex_data.ptr);
                
                // Draw this sprite
                c.glDrawElements(c.GL_TRIANGLES, INDICES_PER_SPRITE, c.GL_UNSIGNED_INT, null);
                
                rendered_sprites += 1;
            }
        }
    }

    pub fn deinit(self: *Renderer) void {
        c.glDeleteVertexArrays(1, &self.VAO);
        c.glDeleteBuffers(1, &self.VBO);
        c.glDeleteBuffers(1, &self.EBO);
        self.shader.deinit();
    }
};