const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});

pub const Shader = struct {
    id: c_uint,

    pub fn init(vertex_source: []const u8, fragment_source: []const u8) !Shader {
        const vertex_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
        c.glShaderSource(vertex_shader, 1, &vertex_source.ptr, null);
        c.glCompileShader(vertex_shader);

        var success: c_int = undefined;
        var info_log: [512]u8 = undefined;
        c.glGetShaderiv(vertex_shader, c.GL_COMPILE_STATUS, &success);
        if (success == 0) {
            c.glGetShaderInfoLog(vertex_shader, 512, null, &info_log);
            std.debug.print("ERROR::SHADER::VERTEX::COMPILATION_FAILED\n{s}\n", .{info_log});
            return error.ShaderCompilationFailed;
        }

        const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
        c.glShaderSource(fragment_shader, 1, &fragment_source.ptr, null);
        c.glCompileShader(fragment_shader);

        c.glGetShaderiv(fragment_shader, c.GL_COMPILE_STATUS, &success);
        if (success == 0) {
            c.glGetShaderInfoLog(fragment_shader, 512, null, &info_log);
            std.debug.print("ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n{s}\n", .{info_log});
            return error.ShaderCompilationFailed;
        }

        const shader_program = c.glCreateProgram();
        c.glAttachShader(shader_program, vertex_shader);
        c.glAttachShader(shader_program, fragment_shader);
        c.glLinkProgram(shader_program);

        c.glGetProgramiv(shader_program, c.GL_LINK_STATUS, &success);
        if (success == 0) {
            c.glGetProgramInfoLog(shader_program, 512, null, &info_log);
            std.debug.print("ERROR::SHADER::PROGRAM::LINKING_FAILED\n{s}\n", .{info_log});
            return error.ShaderLinkingFailed;
        }

        c.glDeleteShader(vertex_shader);
        c.glDeleteShader(fragment_shader);

        return Shader{ .id = shader_program };
    }

    pub fn use(self: *const Shader) void {
        c.glUseProgram(self.id);
    }

    pub fn setInt(self: *const Shader, name: []const u8, value: c_int) void {
        const location = c.glGetUniformLocation(self.id, name.ptr);
        c.glUniform1i(location, value);
    }
    
    pub fn setVec2(self: *const Shader, name: []const u8, x: f32, y: f32) void {
        const location = c.glGetUniformLocation(self.id, name.ptr);
        c.glUniform2f(location, x, y);
    }

    pub fn deinit(self: *const Shader) void {
        c.glDeleteProgram(self.id);
    }
};