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
    ground_mesh: Mesh,
    arrow_mesh: Mesh,  // New mesh for the arrow
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

        // Define ground plane vertices (position, normal, texcoord)
        const ground_vertices = [_]f32{
            -10.0, 0.0, -10.0,   0.0, 1.0, 0.0,   0.0, 0.0,  // bottom-left
             10.0, 0.0, -10.0,   0.0, 1.0, 0.0,   1.0, 0.0,  // bottom-right
             10.0, 0.0,  10.0,   0.0, 1.0, 0.0,   1.0, 1.0,  // top-right
            -10.0, 0.0,  10.0,   0.0, 1.0, 0.0,   0.0, 1.0,  // top-left
        };

        // Define ground plane indices
        const ground_indices = [_]u32{
            0, 1, 2,    2, 3, 0,  // Single quad
        };

        // Define arrow (pyramid) vertices (position, normal, texcoord)
        const arrow_vertices = [_]f32{
            // Base
            -0.2, 0.0, -0.2,   0.0, -1.0, 0.0,   0.0, 0.0,  // bottom-left
             0.2, 0.0, -0.2,   0.0, -1.0, 0.0,   1.0, 0.0,  // bottom-right
             0.2, 0.0,  0.2,   0.0, -1.0, 0.0,   1.0, 1.0,  // top-right
            -0.2, 0.0,  0.2,   0.0, -1.0, 0.0,   0.0, 1.0,  // top-left
            // Front face
             0.0, 0.4,  0.0,   0.0,  0.0,  1.0,   0.5, 1.0,  // tip
            -0.2, 0.0,  0.2,   0.0,  0.0,  1.0,   0.0, 0.0,  // bottom-left
             0.2, 0.0,  0.2,   0.0,  0.0,  1.0,   1.0, 0.0,  // bottom-right
            // Right face
             0.0, 0.4,  0.0,   1.0,  0.0,  0.0,   0.5, 1.0,  // tip
             0.2, 0.0,  0.2,   1.0,  0.0,  0.0,   0.0, 0.0,  // bottom-left
             0.2, 0.0, -0.2,   1.0,  0.0,  0.0,   1.0, 0.0,  // bottom-right
            // Back face
             0.0, 0.4,  0.0,   0.0,  0.0, -1.0,   0.5, 1.0,  // tip
             0.2, 0.0, -0.2,   0.0,  0.0, -1.0,   0.0, 0.0,  // bottom-left
            -0.2, 0.0, -0.2,   0.0,  0.0, -1.0,   1.0, 0.0,  // bottom-right
            // Left face
             0.0, 0.4,  0.0,  -1.0,  0.0,  0.0,   0.5, 1.0,  // tip
            -0.2, 0.0, -0.2,  -1.0,  0.0,  0.0,   0.0, 0.0,  // bottom-left
            -0.2, 0.0,  0.2,  -1.0,  0.0,  0.0,   1.0, 0.0,  // bottom-right
        };

        // Define arrow indices
        const arrow_indices = [_]u32{
            // Base
            0, 1, 2,    2, 3, 0,
            // Front face
            4, 5, 6,
            // Right face
            7, 8, 9,
            // Back face
            10, 11, 12,
            // Left face
            13, 14, 15,
        };

        const mesh = try Mesh.init(&vertices, &indices);
        const ground_mesh = try Mesh.init(&ground_vertices, &ground_indices);
        const arrow_mesh = try Mesh.init(&arrow_vertices, &arrow_indices);
        const shader = try Shader.init("src/shaders/basic.vert", "src/shaders/basic.frag");

        return CubeDemo{
            .mesh = mesh,
            .ground_mesh = ground_mesh,
            .arrow_mesh = arrow_mesh,
            .shader = shader,
            .position = .{ 0.0, 0.5, 0.0 },  // Start cube slightly above ground
            .rotation = 0.0,
        };
    }

    pub fn deinit(self: *CubeDemo) void {
        self.mesh.deinit();
        self.ground_mesh.deinit();
        self.arrow_mesh.deinit();
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

        // Draw ground first
        const ground_model = matrix.identityMatrix(f32, 4);
        self.shader.setMat4("model", &@as([16]f32, @bitCast(ground_model)));
        self.shader.setMat4("view", &@as([16]f32, @bitCast(view)));
        self.shader.setMat4("projection", &@as([16]f32, @bitCast(projection)));
        self.shader.setVec3("lightPos", 5.0, 5.0, 5.0);
        self.shader.setVec3("viewPos", 0.0, 4.0, 10.0);
        self.shader.setVec3("lightColor", 1.0, 1.0, 1.0);
        self.shader.setVec3("objectColor", 0.3, 0.6, 0.3); // Green for ground
        self.ground_mesh.draw(self.shader.id);

        // Create model matrix with rotation and translation
        var model = matrix.identityMatrix(f32, 4);
        
        // Scale the cube to be smaller
        model[0][0] = 0.5; // Scale X
        model[1][1] = 0.5; // Scale Y
        model[2][2] = 0.5; // Scale Z
        
        // Apply rotation around Y axis
        const cos_r = @cos(self.rotation);
        const sin_r = @sin(self.rotation);
        const scaled_cos = cos_r * 0.5;
        const scaled_sin = sin_r * 0.5;
        model[0][0] = scaled_cos;
        model[0][2] = scaled_sin;
        model[2][0] = -scaled_sin;
        model[2][2] = scaled_cos;

        // Apply translation
        model[3][0] = self.position[0];
        model[3][1] = self.position[1];
        model[3][2] = self.position[2];

        // Draw the cube
        self.shader.setMat4("model", &@as([16]f32, @bitCast(model)));
        self.shader.setVec3("objectColor", 0.8, 0.2, 0.2); // Red for cube
        self.mesh.draw(self.shader.id);

        // Draw the arrow as a child of the cube
        var arrow_model = matrix.identityMatrix(f32, 4);
        
        // First position the arrow in front of origin (in local space)
        arrow_model[3][2] = -2.0; // Move forward in local space
        
        // Scale the arrow to be more visible
        arrow_model[0][0] = 0.75; // Scale X
        arrow_model[1][1] = 0.75; // Scale Y
        arrow_model[2][2] = 0.75; // Scale Z
        
        // Then apply the cube's transformation (rotation and position)
        var cube_transform = matrix.identityMatrix(f32, 4);
        cube_transform[0][0] = scaled_cos;
        cube_transform[0][2] = scaled_sin;
        cube_transform[2][0] = -scaled_sin;
        cube_transform[2][2] = scaled_cos;
        cube_transform[3][0] = self.position[0];
        cube_transform[3][1] = self.position[1];
        cube_transform[3][2] = self.position[2];

        // Apply cube's transformation to arrow's local transform
        arrow_model = matrix.multiply(cube_transform, arrow_model);

        self.shader.setMat4("model", &@as([16]f32, @bitCast(arrow_model)));
        self.shader.setVec3("objectColor", 0.2, 0.2, 0.8); // Blue for arrow
        self.arrow_mesh.draw(self.shader.id);
    }
}; 