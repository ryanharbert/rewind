const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

pub const Shader = struct {
    id: c.GLuint,

    pub fn init(vertex_path: []const u8, fragment_path: []const u8) !Shader {
        const vertex_code = try readFile(vertex_path);
        defer std.heap.page_allocator.free(vertex_code);
        const fragment_code = try readFile(fragment_path);
        defer std.heap.page_allocator.free(fragment_code);

        const vertex_shader = compileShader(vertex_code, c.GL_VERTEX_SHADER);
        const fragment_shader = compileShader(fragment_code, c.GL_FRAGMENT_SHADER);

        const shader_program = c.glCreateProgram();
        c.glAttachShader(shader_program, vertex_shader);
        c.glAttachShader(shader_program, fragment_shader);
        c.glLinkProgram(shader_program);

        var success: c.GLint = undefined;
        c.glGetProgramiv(shader_program, c.GL_LINK_STATUS, &success);
        if (success == 0) {
            var info_log: [512]u8 = undefined;
            c.glGetProgramInfoLog(shader_program, 512, null, &info_log);
            std.debug.print("Shader program linking failed: {s}\n", .{info_log});
            return error.ShaderLinkingFailed;
        }

        c.glDeleteShader(vertex_shader);
        c.glDeleteShader(fragment_shader);

        return Shader{ .id = shader_program };
    }

    pub fn deinit(self: *Shader) void {
        c.glDeleteProgram(self.id);
    }

    pub fn use(self: *Shader) void {
        c.glUseProgram(self.id);
    }

    pub fn setBool(self: *Shader, name: []const u8, value: bool) void {
        c.glUniform1i(c.glGetUniformLocation(self.id, name.ptr), @intFromBool(value));
    }

    pub fn setInt(self: *Shader, name: []const u8, value: i32) void {
        c.glUniform1i(c.glGetUniformLocation(self.id, name.ptr), value);
    }

    pub fn setFloat(self: *Shader, name: []const u8, value: f32) void {
        c.glUniform1f(c.glGetUniformLocation(self.id, name.ptr), value);
    }

    pub fn setVec3(self: *Shader, name: []const u8, x: f32, y: f32, z: f32) void {
        c.glUniform3f(c.glGetUniformLocation(self.id, name.ptr), x, y, z);
    }

    pub fn setMat4(self: *Shader, name: []const u8, mat: *const [16]f32) void {
        c.glUniformMatrix4fv(c.glGetUniformLocation(self.id, name.ptr), 1, c.GL_FALSE, mat);
    }
};

fn compileShader(source: []const u8, shader_type: c.GLenum) c.GLuint {
    const shader = c.glCreateShader(shader_type);
    c.glShaderSource(shader, 1, &source.ptr, null);
    c.glCompileShader(shader);

    var success: c.GLint = undefined;
    c.glGetShaderiv(shader, c.GL_COMPILE_STATUS, &success);
    if (success == 0) {
        var info_log: [512]u8 = undefined;
        c.glGetShaderInfoLog(shader, 512, null, &info_log);
        std.debug.print("Shader compilation failed: {s}\n", .{info_log});
        return 0;
    }

    return shader;
}

fn readFile(path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const stat = try file.stat();
    const buffer = try std.heap.page_allocator.alloc(u8, stat.size);
    _ = try file.read(buffer);

    return buffer;
} 