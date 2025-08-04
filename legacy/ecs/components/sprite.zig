const std = @import("std");

pub const Sprite = struct {
    texture_name: []const u8,
    visible: bool = true,
    tint: struct { r: f32, g: f32, b: f32, a: f32 } = .{ .r = 1.0, .g = 1.0, .b = 1.0, .a = 1.0 },
    layer: i32 = 0,
    
    pub fn setTint(self: *Sprite, r: f32, g: f32, b: f32, a: f32) void {
        self.tint.r = r;
        self.tint.g = g;
        self.tint.b = b;
        self.tint.a = a;
    }
    
    pub fn hide(self: *Sprite) void {
        self.visible = false;
    }
    
    pub fn show(self: *Sprite) void {
        self.visible = true;
    }
};