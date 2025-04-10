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

    // Set up view matrix for camera
    var view = matrix.identityMatrix(f32, 4);
    
    // First translate the camera position
    view[3][0] = 0.0;    // x = 0 (centered)
    view[3][1] = -4.0;   // y = -4 (because we're looking down from above)
    view[3][2] = -10.0;  // z = -10 (moving camera back)

    // Then rotate the camera to look down at the scene
    const pitch = -std.math.pi / 6.0; // -30 degrees (looking down)
    const cos_p = @cos(pitch);
    const sin_p = @sin(pitch);
    
    // Apply pitch rotation
    view[1][1] = cos_p;
    view[1][2] = -sin_p;
    view[2][1] = sin_p;
    view[2][2] = cos_p;

    const aspect_ratio: f32 = 800.0 / 600.0;
    const projection = matrix.perspectiveMatrix(60.0, aspect_ratio, 0.1, 100.0);

    // Main loop
    while (!win.shouldClose()) {
        // Update cube
        demo.update(&win);

        // Clear the screen
        c.glClearColor(0.1, 0.1, 0.2, 1.0); // Darker blue background
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);

        // Draw the cube
        demo.draw(view, projection);

        // Swap buffers and poll events
        win.swapBuffers();
        Window.pollEvents();
    }
} 