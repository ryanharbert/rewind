const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const Window = @import("platform/windows/window.zig").Window;
const CubeDemo = @import("demo/triangle_demo.zig").CubeDemo;
const matrix = @import("math/matrix.zig");

pub fn main() !void {
    // Initialize window
    var win = try Window.init("Cube Demo", 800, 600);
    defer win.deinit();

    // Initialize GLAD
    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return error.GLADInitFailed;
    }

    // Enable depth testing
    c.glEnable(c.GL_DEPTH_TEST);

    // Create cube demo
    var demo = try CubeDemo.init();
    defer demo.deinit();

    // Set up view and projection matrices
    var view = matrix.identityMatrix(f32, 4);
    // Position camera higher and at an angle
    view[3][0] = 0.0;  // x
    view[3][1] = 5.0;  // y (higher)
    view[3][2] = -8.0; // z (further back)
    // Rotate view to look down at an angle
    const angle = std.math.pi / 4.0; // 45 degrees
    view[0][0] = @cos(angle);
    view[0][1] = -@sin(angle);
    view[1][0] = @sin(angle);
    view[1][1] = @cos(angle);

    const aspect_ratio: f32 = 800.0 / 600.0;
    const projection = matrix.perspectiveMatrix(45.0, aspect_ratio, 0.1, 100.0);

    // Main loop
    while (!win.shouldClose()) {
        // Update cube
        demo.update(&win);

        // Clear the screen
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);

        // Draw the cube
        demo.draw(view, projection);

        // Swap buffers and poll events
        win.swapBuffers();
        Window.pollEvents();
    }
} 