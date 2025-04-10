const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const Mesh = @import("mesh.zig").Mesh;

pub const Scene = struct {
    sphere: Mesh,
    floor: Mesh,
    shader_program: c.GLuint,
    model_loc: c.GLint,
    view_loc: c.GLint,
    proj_loc: c.GLint,
    light_pos_loc: c.GLint,
    view_pos_loc: c.GLint,
    light_color_loc: c.GLint,
    object_color_loc: c.GLint,

    pub fn init() !Scene {
        var self: Scene = undefined;

        // Create meshes
        self.sphere = try Mesh.createSphere(0.5, 36, 18);
        self.floor = try Mesh.createFloor(5.0);

        // Create shader program
        const vertex_shader = @embedFile("shaders/3d.vert");
        const fragment_shader = @embedFile("shaders/3d.frag");
        self.shader_program = try createShaderProgram(vertex_shader, fragment_shader);

        // Get uniform locations
        self.model_loc = c.glGetUniformLocation(self.shader_program, "model");
        self.view_loc = c.glGetUniformLocation(self.shader_program, "view");
        self.proj_loc = c.glGetUniformLocation(self.shader_program, "projection");
        self.light_pos_loc = c.glGetUniformLocation(self.shader_program, "lightPos");
        self.view_pos_loc = c.glGetUniformLocation(self.shader_program, "viewPos");
        self.light_color_loc = c.glGetUniformLocation(self.shader_program, "lightColor");
        self.object_color_loc = c.glGetUniformLocation(self.shader_program, "objectColor");

        return self;
    }

    pub fn deinit(self: *Scene) void {
        self.sphere.deinit();
        self.floor.deinit();
        c.glDeleteProgram(self.shader_program);
    }

    pub fn draw(self: *Scene, view: [16]f32, projection: [16]f32) void {
        c.glUseProgram(self.shader_program);

        // Set view and projection matrices
        c.glUniformMatrix4fv(self.view_loc, 1, c.GL_FALSE, &view);
        c.glUniformMatrix4fv(self.proj_loc, 1, c.GL_FALSE, &projection);

        // Set light properties
        c.glUniform3f(self.light_pos_loc, 2.0, 2.0, 2.0);
        c.glUniform3f(self.view_pos_loc, 0.0, 0.0, 3.0);
        c.glUniform3f(self.light_color_loc, 1.0, 1.0, 1.0);

        // Draw sphere
        var model = std.math.identityMatrix(f32, 4);
        model[3][1] = 0.5; // Move sphere up
        c.glUniformMatrix4fv(self.model_loc, 1, c.GL_FALSE, &model);
        c.glUniform3f(self.object_color_loc, 0.5, 0.5, 1.0);
        self.sphere.draw(self.shader_program);

        // Draw floor
        model = std.math.identityMatrix(f32, 4);
        c.glUniformMatrix4fv(self.model_loc, 1, c.GL_FALSE, &model);
        c.glUniform3f(self.object_color_loc, 0.8, 0.8, 0.8);
        self.floor.draw(self.shader_program);
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