const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub const Window = struct {
    width: u32,
    height: u32,
    title: []const u8,
    handle: ?*c.GLFWwindow,

    pub fn init(width: u32, height: u32, title: []const u8) !Window {
        if (c.glfwInit() == 0) {
            return error.GLFWInitFailed;
        }

        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

        const window = c.glfwCreateWindow(@intCast(width), @intCast(height), title.ptr, null, null);
        if (window == null) {
            c.glfwTerminate();
            return error.WindowCreationFailed;
        }

        c.glfwMakeContextCurrent(window);
        c.glfwSwapInterval(1);

        return Window{
            .width = width,
            .height = height,
            .title = title,
            .handle = window,
        };
    }

    pub fn deinit(self: *Window) void {
        if (self.handle) |window| {
            c.glfwDestroyWindow(window);
        }
        c.glfwTerminate();
        self.handle = null;
    }

    pub fn shouldClose(self: *Window) bool {
        if (self.handle) |window| {
            return c.glfwWindowShouldClose(window) != 0;
        }
        return true;
    }

    pub fn pollEvents(self: *Window) void {
        _ = self;
        c.glfwPollEvents();
    }

    pub fn swapBuffers(self: *Window) void {
        if (self.handle) |window| {
            c.glfwSwapBuffers(window);
        }
    }
}; 