const std = @import("std");
const ecs = @import("ecs");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== ECS Implementation Test ===\n", .{});
    
    // Test the current ECS implementation
    try ecs.runCompatibilityTest(allocator);
    
    std.debug.print("\n=== Performance Benchmark ===\n", .{});
    try benchmarkECS(allocator);
    
    std.debug.print("\n=== Query Test ===\n", .{});
    try testQueries(allocator);
}

fn benchmarkECS(allocator: std.mem.Allocator) !void {
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    const start_time = std.time.milliTimestamp();
    
    // Create 1000 entities with various components
    std.debug.print("Creating 1000 entities...\n", .{});
    for (0..1000) |i| {
        const entity = try world.createEntity();
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i) } });
        
        if (i % 2 == 0) {
            try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 1.0, .y = 0.0 } });
        }
        
        if (i % 3 == 0) {
            try world.addComponent(entity, ecs.Sprite{ .texture_name = "test" });
        }
    }
    
    const setup_time = std.time.milliTimestamp() - start_time;
    
    // Run queries - measure init and iteration separately
    var total_init_time: i64 = 0;
    var total_iteration_time: i64 = 0;
    var query_count: u32 = 0;
    
    for (0..100) |_| {
        // Measure query initialization
        const init_start = std.time.milliTimestamp();
        var query = world.query(.{ ecs.Transform, ecs.Physics });
        const init_end = std.time.milliTimestamp();
        total_init_time += (init_end - init_start);
        
        defer {
            // Only deinit for sparse set implementation
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        // Measure query iteration
        const iter_start = std.time.milliTimestamp();
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity;
            count += 1;
        }
        const iter_end = std.time.milliTimestamp();
        total_iteration_time += (iter_end - iter_start);
        
        query_count = count; // Save last count
    }
    
    const query_time = total_init_time + total_iteration_time;
    
    std.debug.print("Setup: {}ms\n", .{setup_time});
    std.debug.print("Query Init (100x): {}ms\n", .{total_init_time});
    std.debug.print("Query Iteration (100x): {}ms\n", .{total_iteration_time});
    std.debug.print("Total Queries (100x): {}ms\n", .{query_time});
    std.debug.print("Entities with Transform+Physics: {}\n", .{query_count});
}

fn testQueries(allocator: std.mem.Allocator) !void {
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    // Create test entities
    const entity1 = try world.createEntity();
    try world.addComponent(entity1, ecs.Transform{ .position = .{ .x = 1.0, .y = 1.0 } });
    try world.addComponent(entity1, ecs.Physics{ .velocity = .{ .x = 5.0, .y = 0.0 } });
    
    const entity2 = try world.createEntity();
    try world.addComponent(entity2, ecs.Transform{ .position = .{ .x = 2.0, .y = 2.0 } });
    try world.addComponent(entity2, ecs.Sprite{ .texture_name = "player" });
    
    const entity3 = try world.createEntity();
    try world.addComponent(entity3, ecs.Transform{ .position = .{ .x = 3.0, .y = 3.0 } });
    try world.addComponent(entity3, ecs.Physics{ .velocity = .{ .x = -2.0, .y = 3.0 } });
    try world.addComponent(entity3, ecs.Sprite{ .texture_name = "enemy" });
    
    // Test Transform + Physics query
    std.debug.print("Entities with Transform + Physics:\n", .{});
    var physics_query = world.query(.{ ecs.Transform, ecs.Physics });
    defer {
        if (@hasDecl(@TypeOf(physics_query), "deinit")) {
            physics_query.deinit();
        }
    }
    
    while (physics_query.next()) |entity| {
        const transform = world.getComponent(entity, ecs.Transform).?;
        const physics = world.getComponent(entity, ecs.Physics).?;
        std.debug.print("  Entity {}: pos=({d}, {d}), vel=({d}, {d})\n", 
            .{ entity, transform.position.x, transform.position.y, physics.velocity.x, physics.velocity.y });
    }
    
    // Test Transform + Sprite query
    std.debug.print("Entities with Transform + Sprite:\n", .{});
    var sprite_query = world.query(.{ ecs.Transform, ecs.Sprite });
    defer {
        if (@hasDecl(@TypeOf(sprite_query), "deinit")) {
            sprite_query.deinit();
        }
    }
    
    while (sprite_query.next()) |entity| {
        const transform = world.getComponent(entity, ecs.Transform).?;
        const sprite = world.getComponent(entity, ecs.Sprite).?;
        std.debug.print("  Entity {}: pos=({d}, {d}), texture={s}\n", 
            .{ entity, transform.position.x, transform.position.y, sprite.texture_name });
    }
    
    // Test all three components
    std.debug.print("Entities with Transform + Physics + Sprite:\n", .{});
    var all_query = world.query(.{ ecs.Transform, ecs.Physics, ecs.Sprite });
    defer {
        if (@hasDecl(@TypeOf(all_query), "deinit")) {
            all_query.deinit();
        }
    }
    
    while (all_query.next()) |entity| {
        std.debug.print("  Entity {}: has all three components\n", .{entity});
    }
}