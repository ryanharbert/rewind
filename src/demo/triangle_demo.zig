const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const Mesh = @import("../core/rendering/mesh.zig").Mesh;
const Shader = @import("../core/rendering/shader.zig").Shader;
const matrix = @import("../math/matrix.zig");

pub const CubeDemo = struct {
    mesh: Mesh,
    shader: Shader,
    position: [3]f32,
    rotation: f32,

    pub fn init() !CubeDemo {
        // Define cube vertices (position, normal, texcoord)
        const vertices = [_]f32{
            // Front face
            -1.0, -1.0,  1.0,   0.0,  0.0,  1.0,   0.0, 0.0,  // bottom-left
             1.0, -1.0,  1.0,   0.0,  0.0,  1.0,   1.0, 0.0,  // bottom-right
             1.0,  1.0,  1.0,   0.0,  0.0,  1.0,   1.0, 1.0,  // top-right
            -1.0,  1.0,  1.0,   0.0,  0.0,  1.0,   0.0, 1.0,  // top-left
            // Back face
            -1.0, -1.0, -1.0,   0.0,  0.0, -1.0,   1.0, 0.0,  // bottom-left
             1.0, -1.0, -1.0,   0.0,  0.0, -1.0,   0.0, 0.0,  // bottom-right
             1.0,  1.0, -1.0,   0.0,  0.0, -1.0,   0.0, 1.0,  // top-right
            -1.0,  1.0, -1.0,   0.0,  0.0, -1.0,   1.0, 1.0,  // top-left
            // Right face
             1.0, -1.0,  1.0,   1.0,  0.0,  0.0,   0.0, 0.0,  // bottom-left
             1.0, -1.0, -1.0,   1.0,  0.0,  0.0,   1.0, 0.0,  // bottom-right
             1.0,  1.0, -1.0,   1.0,  0.0,  0.0,   1.0, 1.0,  // top-right
             1.0,  1.0,  1.0,   1.0,  0.0,  0.0,   0.0, 1.0,  // top-left
            // Left face
            -1.0, -1.0, -1.0,  -1.0,  0.0,  0.0,   0.0, 0.0,  // bottom-left
            -1.0, -1.0,  1.0,  -1.0,  0.0,  0.0,   1.0, 0.0,  // bottom-right
            -1.0,  1.0,  1.0,  -1.0,  0.0,  0.0,   1.0, 1.0,  // top-right
            -1.0,  1.0, -1.0,  -1.0,  0.0,  0.0,   0.0, 1.0,  // top-left
            // Top face
            -1.0,  1.0,  1.0,   0.0,  1.0,  0.0,   0.0, 0.0,  // bottom-left
             1.0,  1.0,  1.0,   0.0,  1.0,  0.0,   1.0, 0.0,  // bottom-right
             1.0,  1.0, -1.0,   0.0,  1.0,  0.0,   1.0, 1.0,  // top-right
            -1.0,  1.0, -1.0,   0.0,  1.0,  0.0,   0.0, 1.0,  // top-left
            // Bottom face
            -1.0, -1.0, -1.0,   0.0, -1.0,  0.0,   0.0, 0.0,  // bottom-left
             1.0, -1.0, -1.0,   0.0, -1.0,  0.0,   1.0, 0.0,  // bottom-right
             1.0, -1.0,  1.0,   0.0, -1.0,  0.0,   1.0, 1.0,  // top-right
            -1.0, -1.0,  1.0,   0.0, -1.0,  0.0,   0.0, 1.0,  // top-left
        };

        // Define indices for the cube (6 faces * 2 triangles * 3 vertices)
        const indices = [_]u32{
            0,  1,  2,    2,  3,  0,   // Front
            4,  5,  6,    6,  7,  4,   // Back
            8,  9,  10,   10, 11, 8,   // Right
            12, 13, 14,   14, 15, 12,  // Left
            16, 17, 18,   18, 19, 16,  // Top
            20, 21, 22,   22, 23, 20,  // Bottom
        };

        const mesh = try Mesh.init(&vertices, &indices);
        const shader = try Shader.init("src/shaders/basic.vert", "src/shaders/basic.frag");

        return CubeDemo{
            .mesh = mesh,
            .shader = shader,
            .position = .{ 0.0, 0.0, 0.0 },
            .rotation = 0.0,
        };
    }

    pub fn deinit(self: *CubeDemo) void {
        self.mesh.deinit();
        self.shader.deinit();
    }

    pub fn update(self: *CubeDemo, window: anytype) void {
        const move_speed: f32 = 0.05;
        const rotate_speed: f32 = 0.02;

        // Forward/backward movement relative to rotation
        if (c.glfwGetKey(window.handle, c.GLFW_KEY_W) == c.GLFW_PRESS) {
            self.position[0] -= @sin(self.rotation) * move_speed;
            self.position[2] -= @cos(self.rotation) * move_speed;
        }
        if (c.glfwGetKey(window.handle, c.GLFW_KEY_S) == c.GLFW_PRESS) {
            self.position[0] += @sin(self.rotation) * move_speed;
            self.position[2] += @cos(self.rotation) * move_speed;
        }

        // Rotation
        if (c.glfwGetKey(window.handle, c.GLFW_KEY_A) == c.GLFW_PRESS) {
            self.rotation += rotate_speed;
        }
        if (c.glfwGetKey(window.handle, c.GLFW_KEY_D) == c.GLFW_PRESS) {
            self.rotation -= rotate_speed;
        }
    }

    pub fn draw(self: *CubeDemo, view: [4][4]f32, projection: [4][4]f32) void {
        self.shader.use();

        // Create model matrix with rotation and translation
        var model = matrix.identityMatrix(f32, 4);
        
        // Apply rotation around Y axis
        const cos_r = @cos(self.rotation);
        const sin_r = @sin(self.rotation);
        model[0][0] = cos_r;
        model[0][2] = sin_r;
        model[2][0] = -sin_r;
        model[2][2] = cos_r;

        // Apply translation
        model[3][0] = self.position[0];
        model[3][1] = self.position[1];
        model[3][2] = self.position[2];

        self.shader.setMat4("model", &@as([16]f32, @bitCast(model)));
        self.shader.setMat4("view", &@as([16]f32, @bitCast(view)));
        self.shader.setMat4("projection", &@as([16]f32, @bitCast(projection)));

        // Set lighting properties
        self.shader.setVec3("lightPos", 2.0, 2.0, 2.0);
        self.shader.setVec3("viewPos", 0.0, 0.0, 3.0);
        self.shader.setVec3("lightColor", 1.0, 1.0, 1.0);
        self.shader.setVec3("objectColor", 0.7, 0.2, 0.2); // Red-ish color

        // Draw the cube
        self.mesh.draw(self.shader.id);
    }
}; 