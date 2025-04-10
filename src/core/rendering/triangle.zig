const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const Input = @import("../input/input.zig").Input;
const Key = @import("../input/input.zig").Key;

const Vertex = struct {
    position: [3]f32,
    color: [3]f32,
};

pub const Triangle = struct {
    vao: c.GLuint,
    vbo: c.GLuint,
    shader_program: c.GLuint,
    position: [2]f32,
    speed: f32,

    pub fn init() !Triangle {
        // Define triangle vertices
        const vertices = [_]Vertex{
            .{ .position = [3]f32{ -0.1, -0.1, 0.0 }, .color = [3]f32{ 1.0, 0.0, 0.0 } }, // Red
            .{ .position = [3]f32{ 0.1, -0.1, 0.0 }, .color = [3]f32{ 0.0, 1.0, 0.0 } },  // Green
            .{ .position = [3]f32{ 0.0, 0.1, 0.0 }, .color = [3]f32{ 0.0, 0.0, 1.0 } },   // Blue
        };

        // Create and bind VAO
        var self: Triangle = undefined;
        c.glGenVertexArrays(1, &self.vao);
        c.glBindVertexArray(self.vao);

        // Create and bind VBO
        c.glGenBuffers(1, &self.vbo);
        c.glBindBuffer(c.GL_ARRAY_BUFFER, self.vbo);
        c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(Vertex) * vertices.len, &vertices, c.GL_STATIC_DRAW);

        // Position attribute
        c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(0));
        c.glEnableVertexAttribArray(0);

        // Color attribute
        c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(@offsetOf(Vertex, "color")));
        c.glEnableVertexAttribArray(1);

        // Create shader program
        const vertex_shader = @embedFile("shaders/triangle.vert");
        const fragment_shader = @embedFile("shaders/triangle.frag");
        self.shader_program = try createShaderProgram(vertex_shader, fragment_shader);

        // Initialize position and speed
        self.position = .{ 0.0, 0.0 };
        self.speed = 0.02;

        return self;
    }

    pub fn deinit(self: *Triangle) void {
        c.glDeleteVertexArrays(1, &self.vao);
        c.glDeleteBuffers(1, &self.vbo);
        c.glDeleteProgram(self.shader_program);
    }

    pub fn update(self: *Triangle, input: *Input) void {
        // Update position based on input
        if (input.isKeyPressed(Key.Left) or input.isKeyPressed(Key.A)) {
            self.position[0] -= self.speed;
        }
        if (input.isKeyPressed(Key.Right) or input.isKeyPressed(Key.D)) {
            self.position[0] += self.speed;
        }
        if (input.isKeyPressed(Key.Up) or input.isKeyPressed(Key.W)) {
            self.position[1] += self.speed;
        }
        if (input.isKeyPressed(Key.Down) or input.isKeyPressed(Key.S)) {
            self.position[1] -= self.speed;
        }

        // Keep triangle within screen bounds
        self.position[0] = std.math.clamp(self.position[0], -1.0, 1.0);
        self.position[1] = std.math.clamp(self.position[1], -1.0, 1.0);
    }

    pub fn draw(self: *Triangle) void {
        c.glUseProgram(self.shader_program);
        
        // Set position uniform
        const pos_loc = c.glGetUniformLocation(self.shader_program, "offset");
        c.glUniform2f(pos_loc, self.position[0], self.position[1]);

        c.glBindVertexArray(self.vao);
        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);
    }
};

fn createShaderProgram(vertex_source: []const u8, fragment_source: []const u8) !c.GLuint {
    const vertex_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
    c.glShaderSource(vertex_shader, 1, &vertex_source.ptr, null);
    c.glCompileShader(vertex_shader);

    const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragment_shader, 1, &fragment_source.ptr, null);
    c.glCompileShader(fragment_shader);

    const program = c.glCreateProgram();
    c.glAttachShader(program, vertex_shader);
    c.glAttachShader(program, fragment_shader);
    c.glLinkProgram(program);

    c.glDeleteShader(vertex_shader);
    c.glDeleteShader(fragment_shader);

    return program;
} 