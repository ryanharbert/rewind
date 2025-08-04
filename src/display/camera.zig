const std = @import("std");

pub const Color = struct {
    r: f32 = 0.0,
    g: f32 = 0.0, 
    b: f32 = 0.0,
    a: f32 = 1.0,
};

pub const Camera = struct {
    width: f32,
    height: f32,
    background_color: Color,
    
    pub fn init(width: f32, height: f32) Camera {
        return Camera{
            .width = width,
            .height = height,
            .background_color = .{ .r = 0.2, .g = 0.4, .b = 0.8, .a = 1.0 }, // Nice blue
        };
    }
    
    pub fn setBackgroundColor(self: *Camera, color: Color) void {
        self.background_color = color;
    }
    
    pub fn getProjectionMatrix(self: *const Camera) [16]f32 {
        // Orthographic projection: left=0, right=width, top=0, bottom=height
        return createOrthoMatrix(0, self.width, self.height, 0, -1, 1);
    }
    
    pub fn resize(self: *Camera, width: f32, height: f32) void {
        self.width = width;
        self.height = height;
    }
};

// Helper function to create orthographic projection matrix
fn createOrthoMatrix(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) [16]f32 {
    return .{
        2.0 / (right - left), 0, 0, 0,
        0, 2.0 / (top - bottom), 0, 0,
        0, 0, -2.0 / (far - near), 0,
        -(right + left) / (right - left), -(top + bottom) / (top - bottom), -(far + near) / (far - near), 1,
    };
}