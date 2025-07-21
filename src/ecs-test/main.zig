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
    
    std.debug.print("\n=== Realistic Game Scenarios ===\n", .{});
    try benchmarkGameScenarios(allocator);
    
    std.debug.print("\n=== Multi-System Game Loop Test ===\n", .{});
    try benchmarkMultiSystemGameLoop(allocator);
    
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
        
        // More iterations for accurate ReleaseFast benchmarking
        const iterations: u32 = if (entity_count <= 1000) 5000 else if (entity_count <= 4000) 2000 else 500;
        
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

fn benchmarkGameScenarios(allocator: std.mem.Allocator) !void {
    // Scenario 1: Sparse Physics (10% physics density) - Many decorative items
    std.debug.print("\n--- SCENARIO 1: Sparse Physics (10% density) ---\n", .{});
    std.debug.print("Simulating: Many decorative items, few physics objects\n", .{});
    try testSparsePhysics(allocator);
    
    // Scenario 2: Bullet Spike (100 base + 400 bullets)
    std.debug.print("\n--- SCENARIO 2: Bullet Spike (100 base + 400 bullets) ---\n", .{});
    std.debug.print("Simulating: Normal game + bullet hell moment\n", .{});
    try testBulletSpike(allocator);
    
    // Scenario 3: Dense Physics (75% physics density) - Particle simulation
    std.debug.print("\n--- SCENARIO 3: Dense Physics (75% density) ---\n", .{});
    std.debug.print("Simulating: Particle system or physics-heavy scene\n", .{});
    try testDensePhysics(allocator);
}

fn testSparsePhysics(allocator: std.mem.Allocator) !void {
    // Test with 1000 entities but only 10% have physics (sparse)
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    const entity_count: u32 = 1000;
    
    // Create entities: All have Transform, only every 10th has Physics
    for (0..entity_count) |i| {
        const entity = try world.createEntity();
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i) } });
        
        if (i % 10 == 0) { // Only 10% have physics
            try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 1.0, .y = 0.0 } });
        }
        
        if (i % 3 == 0) { // Normal sprite distribution
            try world.addComponent(entity, ecs.Sprite{ .texture_name = "decoration" });
        }
    }
    
    // Run physics queries
    try testTransformPhysicsQuery(&world, entity_count, 3000);
}

fn testBulletSpike(allocator: std.mem.Allocator) !void {
    // 100 normal game entities + 400 bullets (all physics)
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    // First 100: Normal game entities (50% physics)
    for (0..100) |i| {
        const entity = try world.createEntity();
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i) } });
        
        if (i % 2 == 0) { // 50% have physics
            try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 1.0, .y = 0.0 } });
        }
        
        if (i % 3 == 0) {
            try world.addComponent(entity, ecs.Sprite{ .texture_name = "gameobject" });
        }
    }
    
    // Next 400: Bullets (all have physics)
    for (100..500) |i| {
        const entity = try world.createEntity();
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i) } });
        try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 10.0, .y = 5.0 } }); // All bullets have physics
        try world.addComponent(entity, ecs.Sprite{ .texture_name = "bullet" }); // All bullets have sprites
    }
    
    std.debug.print("Total entities: 500 (100 game objects + 400 bullets)\n", .{});
    try testTransformPhysicsQuery(&world, 500, 3000);
}

fn testDensePhysics(allocator: std.mem.Allocator) !void {
    // Test with 1000 entities but 75% have physics (particle system)
    var world = ecs.World.init(allocator);
    defer world.deinit();
    
    const entity_count: u32 = 1000;
    
    // Create entities: All have Transform, 75% have Physics
    for (0..entity_count) |i| {
        const entity = try world.createEntity();
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i) } });
        
        if (i % 4 != 0) { // 75% have physics (skip every 4th)
            try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 1.0, .y = 0.0 } });
        }
        
        if (i % 5 == 0) { // Fewer sprites for particles
            try world.addComponent(entity, ecs.Sprite{ .texture_name = "particle" });
        }
    }
    
    // Run physics queries
    try testTransformPhysicsQuery(&world, entity_count, 3000);
}

fn benchmarkMultiSystemGameLoop(allocator: std.mem.Allocator) !void {
    // Test multiple scales for comprehensive analysis
    const scales = [_]u32{ 1000, 2000, 4000 };
    
    for (scales) |entity_count| {
        std.debug.print("\n=== Testing realistic game loop with multiple systems on {} entities ===\n", .{entity_count});
        try testGameLoopAtScale(allocator, entity_count);
    }
}

fn testGameLoopAtScale(allocator: std.mem.Allocator, entity_count: u32) !void {
    var world = ecs.World.init(allocator);
    defer world.deinit();
    std.debug.print("Creating mixed entity distribution:\n", .{});
    
    // Create realistic mixed entity distribution
    for (0..entity_count) |i| {
        const entity = try world.createEntity();
        
        // All entities have Transform (position in world)
        try world.addComponent(entity, ecs.Transform{ .position = .{ .x = @floatFromInt(i), .y = @floatFromInt(i % 100) } });
        
        // 50% have Physics (moving objects: players, bullets, physics objects)
        if (i % 2 == 0) {
            try world.addComponent(entity, ecs.Physics{ .velocity = .{ .x = 1.0, .y = 0.5 } });
        }
        
        // 33% have Sprite (visible objects: not all entities are rendered)
        if (i % 3 == 0) {
            const sprite_type = if (i < 100) "player" else if (i < 300) "bullet" else if (i < 600) "enemy" else "decoration";
            try world.addComponent(entity, ecs.Sprite{ .texture_name = sprite_type });
        }
    }
    
    const physics_count = entity_count / 2;
    const sprite_count = entity_count / 3;
    std.debug.print("- {} entities with Transform (100%)\n", .{entity_count});
    std.debug.print("- {} entities with Physics (50%)\n", .{physics_count});
    std.debug.print("- {} entities with Sprite (33%)\n", .{sprite_count});
    
    // Now simulate realistic game systems
    const iterations: u32 = 1000; // Simulate 1000 game frames
    
    std.debug.print("\nSimulating {} game loop iterations with multiple systems:\n", .{iterations});
    
    // System 1: Ability System (queries entities with specific components)
    std.debug.print("1. Ability System (Transform + Sprite for ability targeting)\n", .{});
    try testAbilitySystem(&world, iterations);
    
    // System 2: Bullet Movement (Transform only - all bullets move)
    std.debug.print("2. Bullet Movement System (Transform only for position updates)\n", .{});
    try testBulletMovementSystem(&world, iterations);
    
    // System 3: Physics System (Physics + Transform - the core 50% physics entities)
    std.debug.print("3. Physics System (Physics + Transform for 50% of entities)\n", .{});
    try testPhysicsSystemCore(&world, iterations);
    
    // System 4: Navigation System (Physics for pathfinding, some have sprites for rendering)
    std.debug.print("4. Navigation System (Physics for movement decisions)\n", .{});
    try testNavigationSystem(&world, iterations);
    
    // System 5: AI System (complex combinations)
    std.debug.print("5. AI System (Transform + Physics + Sprite combinations)\n", .{});
    try testAISystem(&world, iterations);
}

fn testAbilitySystem(world: *ecs.World, iterations: u32) !void {
    var total_time: i64 = 0;
    var entity_count: u32 = 0;
    
    for (0..iterations) |_| {
        const start_time = std.time.milliTimestamp();
        
        var query = world.query(.{ ecs.Transform, ecs.Sprite }); // Ability targeting needs visible entities
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity; // Simulate ability logic
            count += 1;
        }
        entity_count = count;
        
        const end_time = std.time.milliTimestamp();
        total_time += (end_time - start_time);
    }
    
    std.debug.print("   {}x queries: {}ms total, {} entities per query\n", .{ iterations, total_time, entity_count });
}

fn testBulletMovementSystem(world: *ecs.World, iterations: u32) !void {
    var total_time: i64 = 0;
    var entity_count: u32 = 0;
    
    for (0..iterations) |_| {
        const start_time = std.time.milliTimestamp();
        
        var query = world.query(.{ecs.Transform}); // All entities need position updates
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity; // Simulate transform update
            count += 1;
        }
        entity_count = count;
        
        const end_time = std.time.milliTimestamp();
        total_time += (end_time - start_time);
    }
    
    std.debug.print("   {}x queries: {}ms total, {} entities per query\n", .{ iterations, total_time, entity_count });
}

fn testPhysicsSystemCore(world: *ecs.World, iterations: u32) !void {
    var total_time: i64 = 0;
    var entity_count: u32 = 0;
    
    for (0..iterations) |_| {
        const start_time = std.time.milliTimestamp();
        
        var query = world.query(.{ ecs.Transform, ecs.Physics }); // Core physics entities
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity; // Simulate physics calculation
            count += 1;
        }
        entity_count = count;
        
        const end_time = std.time.milliTimestamp();
        total_time += (end_time - start_time);
    }
    
    std.debug.print("   {}x queries: {}ms total, {} entities per query\n", .{ iterations, total_time, entity_count });
}

fn testNavigationSystem(world: *ecs.World, iterations: u32) !void {
    var total_time: i64 = 0;
    var entity_count: u32 = 0;
    
    for (0..iterations) |_| {
        const start_time = std.time.milliTimestamp();
        
        var query = world.query(.{ecs.Physics}); // Navigation uses physics entities for pathfinding
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity; // Simulate pathfinding logic
            count += 1;
        }
        entity_count = count;
        
        const end_time = std.time.milliTimestamp();
        total_time += (end_time - start_time);
    }
    
    std.debug.print("   {}x queries: {}ms total, {} entities per query\n", .{ iterations, total_time, entity_count });
}

fn testAISystem(world: *ecs.World, iterations: u32) !void {
    var total_time: i64 = 0;
    var entity_count: u32 = 0;
    
    for (0..iterations) |_| {
        const start_time = std.time.milliTimestamp();
        
        var query = world.query(.{ ecs.Transform, ecs.Physics, ecs.Sprite }); // AI needs all three for decision making
        defer {
            if (@hasDecl(@TypeOf(query), "deinit")) {
                query.deinit();
            }
        }
        
        var count: u32 = 0;
        while (query.next()) |entity| {
            _ = entity; // Simulate AI decision logic
            count += 1;
        }
        entity_count = count;
        
        const end_time = std.time.milliTimestamp();
        total_time += (end_time - start_time);
    }
    
    std.debug.print("   {}x queries: {}ms total, {} entities per query\n", .{ iterations, total_time, entity_count });
}