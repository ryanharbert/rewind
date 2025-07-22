// Rendering bridge between ECS and engine presentation layer
const std = @import("std");
const components = @import("components.zig");
const ecs = @import("ecs");

const Transform = components.Transform;
const Sprite = components.Sprite;

// Render data passed to the engine
pub const RenderSprite = struct {
    texture_name: []const u8,
    position: components.Vec2,
    rotation: f32,
    scale: components.Vec2,
};

// Extract render data from ECS world for presentation
pub fn extractRenderData(world: anytype, allocator: std.mem.Allocator) ![]RenderSprite {
    var sprites = std.ArrayList(RenderSprite).init(allocator);
    
    var query = try world.query(&[_]type{ Transform, Sprite });
    defer query.deinit();
    
    while (query.next()) |entity| {
        const transform = world.getComponent(entity, Transform).?;
        const sprite = world.getComponent(entity, Sprite).?;
        
        try sprites.append(RenderSprite{
            .texture_name = sprite.texture_name,
            .position = transform.position,
            .rotation = transform.rotation,
            .scale = transform.scale,
        });
    }
    
    return sprites.toOwnedSlice();
}