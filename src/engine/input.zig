const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});
const math = @import("math.zig");

// Key enumeration (commonly used keys)
pub const Key = enum(c_int) {
    // Movement keys
    w = c.GLFW_KEY_W,
    a = c.GLFW_KEY_A,
    s = c.GLFW_KEY_S,
    d = c.GLFW_KEY_D,
    
    // Arrow keys
    up = c.GLFW_KEY_UP,
    down = c.GLFW_KEY_DOWN,
    left = c.GLFW_KEY_LEFT,
    right = c.GLFW_KEY_RIGHT,
    
    // Common keys
    space = c.GLFW_KEY_SPACE,
    enter = c.GLFW_KEY_ENTER,
    escape = c.GLFW_KEY_ESCAPE,
};

// Mouse button enumeration
pub const MouseButton = enum(c_int) {
    left = c.GLFW_MOUSE_BUTTON_LEFT,
    right = c.GLFW_MOUSE_BUTTON_RIGHT,
    middle = c.GLFW_MOUSE_BUTTON_MIDDLE,
};

// Simple input state manager
pub const Input = struct {
    window: *anyopaque,
    
    // Keyboard state
    keys_current: [512]bool,
    keys_previous: [512]bool,
    
    // Mouse state
    mouse_buttons_current: [8]bool,
    mouse_buttons_previous: [8]bool,
    mouse_x: f64,
    mouse_y: f64,
    
    pub fn init(window: *anyopaque) Input {
        return Input{
            .window = window,
            .keys_current = [_]bool{false} ** 512,
            .keys_previous = [_]bool{false} ** 512,
            .mouse_buttons_current = [_]bool{false} ** 8,
            .mouse_buttons_previous = [_]bool{false} ** 8,
            .mouse_x = 0.0,
            .mouse_y = 0.0,
        };
    }
    
    pub fn update(self: *Input) void {
        // Update previous state
        self.keys_previous = self.keys_current;
        self.mouse_buttons_previous = self.mouse_buttons_current;
        
        const glfw_window: ?*c.GLFWwindow = @ptrCast(self.window);
        
        // Poll current keyboard state
        inline for (std.meta.fields(Key)) |field| {
            const key_code = @as(c_int, @intFromEnum(@field(Key, field.name)));
            if (key_code < 512) {
                self.keys_current[@intCast(key_code)] = (c.glfwGetKey(glfw_window, key_code) == c.GLFW_PRESS);
            }
        }
        
        // Poll current mouse button state
        inline for (std.meta.fields(MouseButton)) |field| {
            const button_code = @as(c_int, @intFromEnum(@field(MouseButton, field.name)));
            if (button_code < 8) {
                self.mouse_buttons_current[@intCast(button_code)] = (c.glfwGetMouseButton(glfw_window, button_code) == c.GLFW_PRESS);
            }
        }
        
        // Get mouse position
        c.glfwGetCursorPos(glfw_window, &self.mouse_x, &self.mouse_y);
    }
    
    // Key state queries
    pub fn isKeyDown(self: *const Input, key: Key) bool {
        const key_code = @as(usize, @intCast(@intFromEnum(key)));
        return key_code < 512 and self.keys_current[key_code];
    }
    
    pub fn isKeyPressed(self: *const Input, key: Key) bool {
        const key_code = @as(usize, @intCast(@intFromEnum(key)));
        return key_code < 512 and self.keys_current[key_code] and !self.keys_previous[key_code];
    }
    
    pub fn isKeyReleased(self: *const Input, key: Key) bool {
        const key_code = @as(usize, @intCast(@intFromEnum(key)));
        return key_code < 512 and !self.keys_current[key_code] and self.keys_previous[key_code];
    }
    
    // Mouse button state queries
    pub fn isMouseButtonDown(self: *const Input, button: MouseButton) bool {
        const button_code = @as(usize, @intCast(@intFromEnum(button)));
        return button_code < 8 and self.mouse_buttons_current[button_code];
    }
    
    pub fn isMouseButtonPressed(self: *const Input, button: MouseButton) bool {
        const button_code = @as(usize, @intCast(@intFromEnum(button)));
        return button_code < 8 and self.mouse_buttons_current[button_code] and !self.mouse_buttons_previous[button_code];
    }
    
    // Mouse position
    pub fn getMousePosition(self: *const Input) math.Vec2f {
        return math.Vec2f.init(@floatCast(self.mouse_x), @floatCast(self.mouse_y));
    }
    
    // Utility function for WASD movement
    pub fn getMovementVector(self: *const Input) math.Vec2 {
        var movement = math.Vec2.init(0.0, 0.0);
        
        if (self.isKeyDown(.w) or self.isKeyDown(.up)) {
            movement = movement.add(math.Vec2.init(0.0, 1.0));
        }
        if (self.isKeyDown(.s) or self.isKeyDown(.down)) {
            movement = movement.add(math.Vec2.init(0.0, -1.0));
        }
        if (self.isKeyDown(.a) or self.isKeyDown(.left)) {
            movement = movement.add(math.Vec2.init(-1.0, 0.0));
        }
        if (self.isKeyDown(.d) or self.isKeyDown(.right)) {
            movement = movement.add(math.Vec2.init(1.0, 0.0));
        }
        
        return movement;
    }
};