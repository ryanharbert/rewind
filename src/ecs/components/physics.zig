const std = @import("std");

pub const Physics = struct {
    velocity: struct { x: f32, y: f32 } = .{ .x = 0.0, .y = 0.0 },
    acceleration: struct { x: f32, y: f32 } = .{ .x = 0.0, .y = 0.0 },
    mass: f32 = 1.0,
    is_static: bool = false,
    
    pub fn applyForce(self: *Physics, fx: f32, fy: f32) void {
        if (!self.is_static) {
            self.acceleration.x += fx / self.mass;
            self.acceleration.y += fy / self.mass;
        }
    }
    
    pub fn update(self: *Physics, dt: f32) void {
        if (!self.is_static) {
            self.velocity.x += self.acceleration.x * dt;
            self.velocity.y += self.acceleration.y * dt;
            
            // Reset acceleration after applying
            self.acceleration.x = 0.0;
            self.acceleration.y = 0.0;
        }
    }
};