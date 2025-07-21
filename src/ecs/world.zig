const std = @import("std");
const build_options = @import("build_options");

// Comptime switch between implementations
const USE_BITSET_ECS = build_options.use_bitset_ecs;

pub const World = if (USE_BITSET_ECS) 
    @import("bitset/world.zig").World 
else 
    @import("sparse_set/world.zig").World;

pub const Query = if (USE_BITSET_ECS)
    @import("bitset/query.zig").Query
else 
    @import("sparse_set/query.zig").Query;

// Re-export components (same for both implementations)
pub const components = @import("components/mod.zig");
pub const Transform = components.Transform;
pub const Physics = components.Physics;
pub const Sprite = components.Sprite;
pub const Player = components.Player;
pub const Enemy = components.Enemy;

// Common EntityID type
pub const EntityID = u32;

// Test function to verify both implementations work identically
pub fn runCompatibilityTest(allocator: std.mem.Allocator) !void {
    var world = World.init(allocator);
    defer world.deinit();
    
    const entity = try world.createEntity();
    try world.addComponent(entity, Transform{ .position = .{ .x = 1.0, .y = 2.0 } });
    
    std.debug.print("ECS Implementation: {s}\n", .{if (USE_BITSET_ECS) "Bitset" else "Sparse Set"});
    std.debug.print("Entity {} has transform: {}\n", .{ entity, world.hasComponent(entity, Transform) });
    
    if (world.getComponent(entity, Transform)) |transform| {
        std.debug.print("Transform position: ({d}, {d})\n", .{ transform.position.x, transform.position.y });
    }
}