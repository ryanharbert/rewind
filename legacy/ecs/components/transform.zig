const std = @import("std");

pub const Transform = struct {
    position: struct { x: f32, y: f32 },
    rotation: f32 = 0.0,
    scale: struct { x: f32, y: f32 } = .{ .x = 1.0, .y = 1.0 },
    
    pub fn translate(self: *Transform, dx: f32, dy: f32) void {
        self.position.x += dx;
        self.position.y += dy;
    }
    
    pub fn rotate(self: *Transform, angle: f32) void {
        self.rotation += angle;
    }
    
    pub fn setScale(self: *Transform, sx: f32, sy: f32) void {
        self.scale.x = sx;
        self.scale.y = sy;
    }
};