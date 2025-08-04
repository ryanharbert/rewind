const std = @import("std");
const math = @import("math.zig");

pub const Camera = struct {
    position: struct { x: f32, y: f32 },
    zoom: f32,
    aspect_ratio: f32,
    
    pub fn init(x: f32, y: f32, zoom: f32) Camera {
        return Camera{
            .position = .{ .x = x, .y = y },
            .zoom = zoom,
            .aspect_ratio = 1.0,
        };
    }
    
    pub fn setPosition(self: *Camera, x: f32, y: f32) void {
        self.position.x = x;
        self.position.y = y;
    }
    
    pub fn translate(self: *Camera, dx: f32, dy: f32) void {
        self.position.x += dx;
        self.position.y += dy;
    }
    
    pub fn setZoom(self: *Camera, zoom: f32) void {
        self.zoom = @max(0.1, zoom); // Prevent zero/negative zoom
    }
    
    pub fn adjustZoom(self: *Camera, delta: f32) void {
        self.setZoom(self.zoom + delta);
    }
    
    pub fn setAspectRatio(self: *Camera, aspect_ratio: f32) void {
        self.aspect_ratio = aspect_ratio;
    }
    
    // Follow a target position smoothly
    pub fn followTarget(self: *Camera, target_x: f32, target_y: f32, delta_time: f32, follow_speed: f32) void {
        const dx = target_x - self.position.x;
        const dy = target_y - self.position.y;
        
        const lerp_factor = 1.0 - @exp(-follow_speed * delta_time);
        self.position.x += dx * lerp_factor;
        self.position.y += dy * lerp_factor;
    }
    
    // Convert world coordinates to screen coordinates
    pub fn worldToScreen(self: *Camera, world_x: f32, world_y: f32) math.Vec2 {
        const view_x = (world_x - self.position.x) * self.zoom;
        const view_y = (world_y - self.position.y) * self.zoom;
        
        return math.Vec2.init(
            view_x / self.aspect_ratio,
            view_y
        );
    }
    
    // Get the view matrix for rendering
    pub fn getViewMatrix(self: *Camera) [16]f32 {
        // Create a simple 2D view matrix
        // This transforms world coordinates to camera space
        const scale_x = self.zoom / self.aspect_ratio;
        const scale_y = self.zoom;
        const translate_x = -self.position.x * scale_x;
        const translate_y = -self.position.y * scale_y;
        
        return [16]f32{
            scale_x,  0.0,      0.0, 0.0,
            0.0,      scale_y,  0.0, 0.0,
            0.0,      0.0,      1.0, 0.0,
            translate_x, translate_y, 0.0, 1.0,
        };
    }
    
    // Get camera bounds in world space (useful for culling)
    pub fn getWorldBounds(self: *Camera) struct { left: f32, right: f32, top: f32, bottom: f32 } {
        const half_width = (1.0 / self.zoom) * self.aspect_ratio;
        const half_height = 1.0 / self.zoom;
        
        return .{
            .left = self.position.x - half_width,
            .right = self.position.x + half_width,
            .top = self.position.y + half_height,
            .bottom = self.position.y - half_height,
        };
    }
};