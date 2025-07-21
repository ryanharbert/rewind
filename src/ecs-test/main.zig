const std = @import("std");
const ecs = @import("ecs");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== ECS Implementation Test ===\n", .{});
    
    // Test the current ECS implementation
    try ecs.runCompatibilityTest(allocator);
    
    std.debug.print("\n=== Original Simple Test (100 iterations) ===\n", .{});
    try originalSimpleTest(allocator);
    
    std.debug.print("\n=== Performance Benchmark ===\n", .{});
    try benchmarkECS(allocator);
    
    std.debug.print("\n=== Query Test ===\n", .{});
    try testQueries(allocator);
}

fn originalSimpleTest(allocator: std.mem.Allocator) !void {
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    const start_time = std.time.milliTimestamp();
    
    // Create 1000 entities (same as before)
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
    
    // Run queries - 100 iterations like the original test
    var total_init_time: i64 = 0;
    var total_iteration_time: i64 = 0;
    var query_count: u32 = 0;
    
    for (0..100) |_| {  // 100 iterations - same as original
        const init_start = std.time.milliTimestamp();
        var query = world.query(.{ ecs.Transform, ecs.Physics });
        const init_end = std.time.milliTimestamp();
        total_init_time += (init_end - init_start);
        
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        const iter_start = std.time.milliTimestamp();
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity;
            count += 1;
        }
        const iter_end = std.time.milliTimestamp();
        total_iteration_time += (iter_end - iter_start);
        query_count = count;
    }
    
    const query_time = total_init_time + total_iteration_time;
    
    std.debug.print("Setup: {}ms\n", .{setup_time});
    std.debug.print("Query Init (100x): {}ms\n", .{total_init_time});
    std.debug.print("Query Iteration (100x): {}ms\n", .{total_iteration_time});
    std.debug.print("Total Queries (100x): {}ms\n", .{query_time});
    std.debug.print("Entities with Transform+Physics: {}\n", .{query_count});
}

fn benchmarkECS(allocator: std.mem.Allocator) !void {
    std.debug.print("\n=== COMPREHENSIVE ECS BENCHMARK ===\n", .{});
    
    // Test different entity counts up to very large scales
    const entity_counts = [_]u32{ 100, 500, 1000, 2000, 4000, 8000, 16000 };
    
    for (entity_counts) |entity_count| {
        // Skip very large entity counts for bitset ECS (simplify for now)
        if (entity_count > 4096) {
            std.debug.print("Skipping {} entities (exceeds bitset limit)\n", .{entity_count});
            continue;
        }
        
        std.debug.print("\n--- Testing with {} entities ---\n", .{entity_count});
        
        var world = ecs.World.init(allocator);
        defer world.deinit();
        
        const start_time = std.time.milliTimestamp();
        
        // Create entities with different component distributions
        for (0..entity_count) |i| {
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
        
        // Adjust iterations based on entity count to keep tests reasonable
        const iterations: u32 = if (entity_count <= 1000) 1000 else if (entity_count <= 4000) 500 else 100;
        
        // Test Transform+Physics query (50% selectivity)
        try testTransformPhysicsQuery(&world, entity_count, iterations);
        
        // Test Transform+Sprite query (33% selectivity)  
        try testTransformSpriteQuery(&world, entity_count, iterations);
        
        // Test Transform+Physics+Sprite query (16% selectivity)
        try testAllComponentsQuery(&world, entity_count, iterations);
        
        std.debug.print("Setup time: {}ms\n", .{setup_time});
    }
}

fn testTransformPhysicsQuery(world: *ecs.World, entity_count: u32, iterations: u32) !void {
    var total_init_time: i64 = 0;
    var total_iteration_time: i64 = 0;
    var query_count: u32 = 0;
    
    for (0..iterations) |_| {
        const init_start = std.time.milliTimestamp();
        var query = world.query(.{ ecs.Transform, ecs.Physics });
        const init_end = std.time.milliTimestamp();
        total_init_time += (init_end - init_start);
        
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        const iter_start = std.time.milliTimestamp();
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity;
            count += 1;
        }
        const iter_end = std.time.milliTimestamp();
        total_iteration_time += (iter_end - iter_start);
        query_count = count;
    }
    
    const total_time = total_init_time + total_iteration_time;
    const selectivity = (@as(f32, @floatFromInt(query_count)) / @as(f32, @floatFromInt(entity_count))) * 100.0;
    std.debug.print("Transform+Physics ({}x): Init={}ms, Iter={}ms, Total={}ms, Matches={} ({d:.1}%)\n", 
        .{ iterations, total_init_time, total_iteration_time, total_time, query_count, selectivity });
}

fn testTransformSpriteQuery(world: *ecs.World, entity_count: u32, iterations: u32) !void {
    var total_init_time: i64 = 0;
    var total_iteration_time: i64 = 0;
    var query_count: u32 = 0;
    
    for (0..iterations) |_| {
        const init_start = std.time.milliTimestamp();
        var query = world.query(.{ ecs.Transform, ecs.Sprite });
        const init_end = std.time.milliTimestamp();
        total_init_time += (init_end - init_start);
        
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        const iter_start = std.time.milliTimestamp();
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity;
            count += 1;
        }
        const iter_end = std.time.milliTimestamp();
        total_iteration_time += (iter_end - iter_start);
        query_count = count;
    }
    
    const total_time = total_init_time + total_iteration_time;
    const selectivity = (@as(f32, @floatFromInt(query_count)) / @as(f32, @floatFromInt(entity_count))) * 100.0;
    std.debug.print("Transform+Sprite ({}x): Init={}ms, Iter={}ms, Total={}ms, Matches={} ({d:.1}%)\n", 
        .{ iterations, total_init_time, total_iteration_time, total_time, query_count, selectivity });
}

fn testAllComponentsQuery(world: *ecs.World, entity_count: u32, iterations: u32) !void {
    var total_init_time: i64 = 0;
    var total_iteration_time: i64 = 0;
    var query_count: u32 = 0;
    
    for (0..iterations) |_| {
        const init_start = std.time.milliTimestamp();
        var query = world.query(.{ ecs.Transform, ecs.Physics, ecs.Sprite });
        const init_end = std.time.milliTimestamp();
        total_init_time += (init_end - init_start);
        
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        const iter_start = std.time.milliTimestamp();
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity;
            count += 1;
        }
        const iter_end = std.time.milliTimestamp();
        total_iteration_time += (iter_end - iter_start);
        query_count = count;
    }
    
    const total_time = total_init_time + total_iteration_time;
    const selectivity = (@as(f32, @floatFromInt(query_count)) / @as(f32, @floatFromInt(entity_count))) * 100.0;
    std.debug.print("Transform+Physics+Sprite ({}x): Init={}ms, Iter={}ms, Total={}ms, Matches={} ({d:.1}%)\n", 
        .{ iterations, total_init_time, total_iteration_time, total_time, query_count, selectivity });
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