const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const platform = @import("../platform/common/platform.zig");
const window = @import("../platform/windows/window.zig");
const input = @import("../platform/windows/input.zig");

const Vertex = struct {
    x: f32,
    y: f32,
    z: f32,
    r: f32,
    g: f32,
    b: f32,
};

pub fn run() !void {
    if (!platform.isWindows()) {
        std.debug.print("This demo only supports Windows for now\n", .{});
        return;
    }

    // Initialize window
    var win = try window.Window.init(800, 600, "Triangle Demo");
    defer win.deinit();

    // Initialize input
    var inp = input.Input.init(win.handle);

    // Initialize GLAD
    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    // Enable depth testing
    c.glEnable(c.GL_DEPTH_TEST);

    // Create and compile shaders
    const shader_program = try createShaderProgram();

    // Define triangle vertices
    const vertices = [_]Vertex{
        .{ .x = -0.5, .y = -0.5, .z = 0.0, .r = 1.0, .g = 0.0, .b = 0.0 }, // Red
        .{ .x = 0.5, .y = -0.5, .z = 0.0, .r = 0.0, .g = 1.0, .b = 0.0 },  // Green
        .{ .x = 0.0, .y = 0.5, .z = 0.0, .r = 0.0, .g = 0.0, .b = 1.0 },   // Blue
    };

    // Create and bind VAO
    var vao: c_uint = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    // Create and bind VBO
    var vbo: c_uint = undefined;
    c.glGenBuffers(1, &vbo);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(Vertex) * vertices.len, &vertices, c.GL_STATIC_DRAW);

    // Position attribute
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(0));
    c.glEnableVertexAttribArray(0);

    // Color attribute
    c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(3 * @sizeOf(f32)));
    c.glEnableVertexAttribArray(1);

    // Position offset for movement
    var pos_x: f32 = 0.0;
    var pos_y: f32 = 0.0;
    const move_speed: f32 = 0.02;

    // Get uniform location
    const offset_loc = c.glGetUniformLocation(shader_program, "offset");

    // Main render loop
    while (!win.shouldClose()) {
        // Process input
        if (inp.isKeyPressed(.Escape)) {
            win.setShouldClose(true);
        }

        // Update position based on input
        if (inp.isKeyPressed(.W)) pos_y += move_speed;
        if (inp.isKeyPressed(.S)) pos_y -= move_speed;
        if (inp.isKeyPressed(.A)) pos_x -= move_speed;
        if (inp.isKeyPressed(.D)) pos_x += move_speed;

        // Keep triangle within bounds
        pos_x = std.math.clamp(pos_x, -1.0, 1.0);
        pos_y = std.math.clamp(pos_y, -1.0, 1.0);

        // Clear the screen
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);

        // Use shader program and update position
        c.glUseProgram(shader_program);
        c.glUniform2f(offset_loc, pos_x, pos_y);

        // Draw triangle
        c.glBindVertexArray(vao);
        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);

        // Swap buffers and poll events
        win.swapBuffers();
        window.Window.pollEvents();
    }
}

fn createShaderProgram() !c_uint {
    const vertex_shader_source: [*:0]const u8 =
        \\#version 330 core
        \\layout (location = 0) in vec3 aPos;
        \\layout (location = 1) in vec3 aColor;
        \\out vec3 ourColor;
        \\uniform vec2 offset;
        \\void main() {
        \\    gl_Position = vec4(aPos.x + offset.x, aPos.y + offset.y, aPos.z, 1.0);
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