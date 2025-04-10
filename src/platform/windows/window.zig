const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

pub const Window = struct {
    handle: *c.GLFWwindow,

    pub fn init(title: []const u8, width: i32, height: i32) !Window {
        if (c.glfwInit() == 0) {
            return error.GLFWInitFailed;
        }

        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

        const window = c.glfwCreateWindow(width, height, title.ptr, null, null) orelse {
            c.glfwTerminate();
            return error.WindowCreationFailed;
        };

        c.glfwMakeContextCurrent(window);
        c.glfwSwapInterval(1); // Enable vsync

        return Window{ .handle = window };
    }

    pub fn deinit(self: *Window) void {
        c.glfwDestroyWindow(self.handle);
        c.glfwTerminate();
    }

    pub fn shouldClose(self: *Window) bool {
        return c.glfwWindowShouldClose(self.handle) != 0;
    }

    pub fn pollEvents() void {
        c.glfwPollEvents();
    }

    pub fn swapBuffers(self: *Window) void {
        c.glfwSwapBuffers(self.handle);
    }
}; 