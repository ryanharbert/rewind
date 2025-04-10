const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const Window = @import("core/window/window.zig").Window;
const Input = @import("core/input/input.zig").Input;
const Key = @import("core/input/input.zig").Key;
const Triangle = @import("core/rendering/triangle.zig").Triangle;

pub fn main() !void {
    var window = try Window.init(800, 600, "Game Engine");
    defer window.deinit();

    // Initialize GLAD
    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        return error.GLADInitFailed;
    }

    var input = Input.init(&window);
    var triangle = try Triangle.init();
    defer triangle.deinit();

    while (!window.shouldClose()) {
        window.pollEvents();

        if (input.isKeyPressed(Key.Escape)) {
            break;
        }

        // Update triangle position
        triangle.update(&input);

        // Clear the screen
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        // Draw the triangle
        triangle.draw();

        window.swapBuffers();
    }
} 