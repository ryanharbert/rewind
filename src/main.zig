const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

const Shader = @import("engine/shader.zig").Shader;
const Texture = @import("engine/texture.zig").Texture;

const vertex_shader_source =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\layout (location = 1) in vec2 aTexCoord;
    \\
    \\out vec2 TexCoord;
    \\
    \\void main()
    \\{
    \\    gl_Position = vec4(aPos, 1.0);
    \\    TexCoord = aTexCoord;
    \\}
;

const fragment_shader_source =
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

fn framebuffer_size_callback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    c.glViewport(0, 0, width, height);
}

pub fn main() !void {
    if (c.glfwInit() == c.GLFW_FALSE) {
        std.debug.print("Failed to initialize GLFW\n", .{});
        return;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    const window = c.glfwCreateWindow(800, 600, "Grapefruit Engine", null, null);
    if (window == null) {
        std.debug.print("Failed to create GLFW window\n", .{});
        return;
    }
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    _ = c.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    // Create shader program
    const shader = Shader.init(vertex_shader_source, fragment_shader_source) catch {
        std.debug.print("Failed to create shader program\n", .{});
        return;
    };
    defer shader.deinit();

    // Create texture (using dummy path for now - will create checkerboard pattern)
    const texture = Texture.init("dummy.png") catch {
        std.debug.print("Failed to create texture\n", .{});
        return;
    };
    defer texture.deinit();

    // Quad vertices with texture coordinates
    const vertices = [_]f32{
        // positions     // texture coords
        0.5,  0.5, 0.0,  1.0, 1.0, // top right
        0.5, -0.5, 0.0,  1.0, 0.0, // bottom right
        -0.5, -0.5, 0.0, 0.0, 0.0, // bottom left
        -0.5,  0.5, 0.0, 0.0, 1.0  // top left
    };

    const indices = [_]c_uint{
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    };

    var VBO: c_uint = undefined;
    var VAO: c_uint = undefined;
    var EBO: c_uint = undefined;
    c.glGenVertexArrays(1, &VAO);
    c.glGenBuffers(1, &VBO);
    c.glGenBuffers(1, &EBO);

    c.glBindVertexArray(VAO);

    c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
    c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, c.GL_STATIC_DRAW);

    c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, EBO);
    c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, @sizeOf(@TypeOf(indices)), &indices, c.GL_STATIC_DRAW);

    // Position attribute
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), null);
    c.glEnableVertexAttribArray(0);

    // Texture coordinate attribute
    c.glVertexAttribPointer(1, 2, c.GL_FLOAT, c.GL_FALSE, 5 * @sizeOf(f32), @ptrFromInt(3 * @sizeOf(f32)));
    c.glEnableVertexAttribArray(1);

    c.glBindBuffer(c.GL_ARRAY_BUFFER, 0);
    c.glBindVertexArray(0);

    // Main loop
    while (c.glfwWindowShouldClose(window) == 0) {
        c.glfwPollEvents();

        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        texture.bind();
        shader.use();
        shader.setInt("ourTexture", 0);
        
        c.glBindVertexArray(VAO);
        c.glDrawElements(c.GL_TRIANGLES, 6, c.GL_UNSIGNED_INT, null);

        c.glfwSwapBuffers(window);
    }

    c.glDeleteVertexArrays(1, &VAO);
    c.glDeleteBuffers(1, &VBO);
    c.glDeleteBuffers(1, &EBO);
}
