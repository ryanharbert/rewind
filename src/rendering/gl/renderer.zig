const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

pub const Renderer = struct {
    window: *c.GLFWwindow,
    shader_program: c_uint,
    screen_width: f32,
    screen_height: f32,

    pub fn init(width: u32, height: u32, title: [*:0]const u8) !Renderer {
        // Initialize GLFW
        if (c.glfwInit() == 0) {
            return error.GLFWInitFailed;
        }

        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

        const window = c.glfwCreateWindow(@intCast(width), @intCast(height), title, null, null) orelse {
            return error.WindowCreationFailed;
        };

        c.glfwMakeContextCurrent(window);
        c.glfwSwapInterval(1);

        if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
            return error.GLADLoadFailed;
        }

        // Enable depth testing
        c.glEnable(c.GL_DEPTH_TEST);

        return Renderer{
            .window = window,
            .shader_program = try createShaderProgram(),
            .screen_width = @floatFromInt(width),
            .screen_height = @floatFromInt(height),
        };
    }

    pub fn deinit(self: *Renderer) void {
        c.glfwDestroyWindow(self.window);
        c.glfwTerminate();
    }

    pub fn shouldClose(self: *Renderer) bool {
        return c.glfwWindowShouldClose(self.window) != 0;
    }

    pub fn beginFrame(self: *Renderer) void {
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);
    }

    pub fn endFrame(self: *Renderer) void {
        c.glfwSwapBuffers(self.window);
        c.glfwPollEvents();
    }
};

fn createShaderProgram() !c_uint {
    const vertex_shader_source: [*:0]const u8 =
        \\#version 330 core
        \\layout (location = 0) in vec3 aPos;
        \\layout (location = 1) in vec3 aColor;
        \\out vec3 ourColor;
        \\uniform mat4 model;
        \\uniform mat4 projection;
        \\void main() {
        \\    gl_Position = projection * model * vec4(aPos, 1.0);
        \\    ourColor = aColor;
        \\}
    ;

    const fragment_shader_source: [*:0]const u8 =
        \\#version 330 core
        \\in vec3 ourColor;
        \\out vec4 FragColor;
        \\void main() {
        \\    FragColor = vec4(ourColor, 1.0);
        \\}
    ;

    const vertex_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
    c.glShaderSource(vertex_shader, 1, &vertex_shader_source, null);
    c.glCompileShader(vertex_shader);

    var success: c_int = undefined;
    c.glGetShaderiv(vertex_shader, c.GL_COMPILE_STATUS, &success);
    if (success == 0) {
        return error.ShaderCompilationFailed;
    }

    const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragment_shader, 1, &fragment_shader_source, null);
    c.glCompileShader(fragment_shader);

    c.glGetShaderiv(fragment_shader, c.GL_COMPILE_STATUS, &success);
    if (success == 0) {
        return error.ShaderCompilationFailed;
    }

    const shader_program = c.glCreateProgram();
    c.glAttachShader(shader_program, vertex_shader);
    c.glAttachShader(shader_program, fragment_shader);
    c.glLinkProgram(shader_program);

    c.glGetProgramiv(shader_program, c.GL_LINK_STATUS, &success);
    if (success == 0) {
        return error.ShaderLinkFailed;
    }

    c.glDeleteShader(vertex_shader);
    c.glDeleteShader(fragment_shader);

    return shader_program;
} 