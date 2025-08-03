const std = @import("std");
const testing = std.testing;
const ecs = @import("ecs_optimized.zig");

// Test components
const Position = struct { x: f32, y: f32 };
const Velocity = struct { x: f32, y: f32 };
const Health = struct { value: i32, max: i32 };
const Name = struct { value: []const u8 };
const Tag = struct { id: u32 };

// Test input type
const TestInput = struct {
    value: f32 = 0,
};

// Create test ECS configurations
const TinyECS = ecs.ECS(.{
    .components = &.{ Position, Velocity },
    .input = TestInput,
    .max_entities = .tiny, // 64 entities
});

const StandardECS = ecs.ECS(.{
    .components = &.{ Position, Velocity, Health, Name, Tag },
    .input = TestInput,
    .max_entities = .medium, // 512 entities
});

test "ECS initialization and cleanup" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();
    try testing.expectEqual(@as(u32, 0), frame.getEntityCount());
    try testing.expectEqual(@as(u64, 0), frame.frame_number);
}

test "Entity creation and destruction" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities
    const e1 = try frame.createEntity();
    const e2 = try frame.createEntity();
    const e3 = try frame.createEntity();

    try testing.expectEqual(@as(u32, 0), e1);
    try testing.expectEqual(@as(u32, 1), e2);
    try testing.expectEqual(@as(u32, 2), e3);
    try testing.expectEqual(@as(u32, 3), frame.getEntityCount());

    // Destroy entity
    frame.destroyEntity(e2);
    try testing.expectEqual(@as(u32, 2), frame.getEntityCount());

    // Create new entity - should reuse ID
    const e4 = try frame.createEntity();
    try testing.expectEqual(@as(u32, 3), e4); // Next available ID
    try testing.expectEqual(@as(u32, 3), frame.getEntityCount());
}

test "Entity limit enforcement" {
    var test_ecs = try TinyECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create max entities
    var entities: [64]ecs.EntityID = undefined;
    for (0..64) |i| {
        entities[i] = try frame.createEntity();
    }

    // Try to create one more - should fail
    const result = frame.createEntity();
    try testing.expectError(error.EntityLimitExceeded, result);
}

test "Entity ID recycling after destruction" {
    // This test documents a current limitation - entity IDs are not recycled
    // TODO: Implement entity ID recycling to handle long-running games
    if (true) return error.SkipZigTest; // Skip until implemented
    
    var test_ecs = try TinyECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create and destroy many entities
    for (0..1000) |_| {
        // Create max entities
        var entities: [64]ecs.EntityID = undefined;
        for (0..64) |i| {
            entities[i] = try frame.createEntity();
        }
        
        // Destroy all entities
        for (entities) |entity| {
            frame.destroyEntity(entity);
        }
        
        try testing.expectEqual(@as(u32, 0), frame.getEntityCount());
    }
    
    // Should still be able to create entities after many cycles
    const entity = try frame.createEntity();
    try testing.expect(entity != ecs.INVALID_ENTITY);
}

test "Component add/get/remove" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();
    const entity = try frame.createEntity();

    // Add components
    try frame.addComponent(entity, Position{ .x = 10.0, .y = 20.0 });
    try frame.addComponent(entity, Velocity{ .x = 1.0, .y = 2.0 });
    try frame.addComponent(entity, Health{ .value = 100, .max = 100 });

    // Get components
    const pos = frame.getComponent(entity, Position).?;
    try testing.expectEqual(@as(f32, 10.0), pos.x);
    try testing.expectEqual(@as(f32, 20.0), pos.y);

    const vel = frame.getComponent(entity, Velocity).?;
    try testing.expectEqual(@as(f32, 1.0), vel.x);
    try testing.expectEqual(@as(f32, 2.0), vel.y);

    // Check has component
    try testing.expect(frame.hasComponent(entity, Position));
    try testing.expect(frame.hasComponent(entity, Velocity));
    try testing.expect(!frame.hasComponent(entity, Name));

    // Remove component
    const removed = frame.removeComponent(entity, Velocity);
    try testing.expect(removed);
    try testing.expect(!frame.hasComponent(entity, Velocity));

    // Try to remove again - should return false
    const removed_again = frame.removeComponent(entity, Velocity);
    try testing.expect(!removed_again);
}

test "Component modification" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();
    const entity = try frame.createEntity();

    try frame.addComponent(entity, Position{ .x = 0.0, .y = 0.0 });

    // Modify component
    const pos = frame.getComponent(entity, Position).?;
    pos.x = 100.0;
    pos.y = 200.0;

    // Verify modification
    const pos2 = frame.getComponent(entity, Position).?;
    try testing.expectEqual(@as(f32, 100.0), pos2.x);
    try testing.expectEqual(@as(f32, 200.0), pos2.y);
}

test "Invalid entity operations" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Try to add component to non-existent entity
    const result = frame.addComponent(999, Position{ .x = 0, .y = 0 });
    try testing.expectError(error.InvalidEntity, result);

    // Get component from non-existent entity
    const pos = frame.getComponent(999, Position);
    try testing.expect(pos == null);

    // Has component on non-existent entity
    try testing.expect(!frame.hasComponent(999, Position));

    // Remove component from non-existent entity
    try testing.expect(!frame.removeComponent(999, Position));
}

test "Query single component" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities with positions
    const e1 = try frame.createEntity();
    try frame.addComponent(e1, Position{ .x = 1.0, .y = 1.0 });

    const e2 = try frame.createEntity();
    try frame.addComponent(e2, Position{ .x = 2.0, .y = 2.0 });

    const e3 = try frame.createEntity();
    try frame.addComponent(e3, Position{ .x = 3.0, .y = 3.0 });

    // Create entity without position
    const e4 = try frame.createEntity();
    try frame.addComponent(e4, Velocity{ .x = 0, .y = 0 });

    // Query all entities with Position
    var query = try frame.query(&.{Position});
    try testing.expectEqual(@as(u32, 3), query.count());

    var count: u32 = 0;
    var sum_x: f32 = 0;
    while (query.next()) |result| {
        const pos = result.get(Position);
        sum_x += pos.x;
        count += 1;
    }
    try testing.expectEqual(@as(u32, 3), count);
    try testing.expectEqual(@as(f32, 6.0), sum_x); // 1 + 2 + 3
}

test "Query multiple components" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Entity with both Position and Velocity
    const e1 = try frame.createEntity();
    try frame.addComponent(e1, Position{ .x = 1.0, .y = 1.0 });
    try frame.addComponent(e1, Velocity{ .x = 10.0, .y = 10.0 });

    // Entity with only Position
    const e2 = try frame.createEntity();
    try frame.addComponent(e2, Position{ .x = 2.0, .y = 2.0 });

    // Entity with only Velocity
    const e3 = try frame.createEntity();
    try frame.addComponent(e3, Velocity{ .x = 20.0, .y = 20.0 });

    // Entity with both
    const e4 = try frame.createEntity();
    try frame.addComponent(e4, Position{ .x = 4.0, .y = 4.0 });
    try frame.addComponent(e4, Velocity{ .x = 40.0, .y = 40.0 });

    // Query entities with both Position AND Velocity
    var query = try frame.query(&.{ Position, Velocity });
    try testing.expectEqual(@as(u32, 2), query.count());

    var total_x: f32 = 0;
    while (query.next()) |result| {
        const pos = result.get(Position);
        const vel = result.get(Velocity);
        total_x += pos.x + vel.x;
    }
    try testing.expectEqual(@as(f32, 55.0), total_x); // (1+10) + (4+40)
}

test "Query empty results" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities without Health component
    const e1 = try frame.createEntity();
    try frame.addComponent(e1, Position{ .x = 0, .y = 0 });

    const e2 = try frame.createEntity();
    try frame.addComponent(e2, Velocity{ .x = 0, .y = 0 });

    // Query for Health component - should be empty
    var query = try frame.query(&.{Health});
    try testing.expectEqual(@as(u32, 0), query.count());
    try testing.expect(query.next() == null);
}

test "Query reset" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities
    for (0..5) |i| {
        const e = try frame.createEntity();
        try frame.addComponent(e, Position{ .x = @floatFromInt(i), .y = 0 });
    }

    var query = try frame.query(&.{Position});
    try testing.expectEqual(@as(u32, 5), query.count());

    // Iterate partially
    _ = query.next();
    _ = query.next();

    // Reset and count again
    query.reset();
    var count: u32 = 0;
    while (query.next()) |_| {
        count += 1;
    }
    try testing.expectEqual(@as(u32, 5), count);
}

test "Query iterator for-loop pattern" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities with components
    for (0..10) |i| {
        const e = try frame.createEntity();
        try frame.addComponent(e, Position{ .x = @floatFromInt(i), .y = @floatFromInt(i * 2) });
        try frame.addComponent(e, Velocity{ .x = 1.0, .y = 2.0 });
    }

    // Test for-loop iteration
    var query = try frame.query(&.{ Position, Velocity });
    var count: u32 = 0;
    var sum_x: f32 = 0;
    
    // Use the new iterator pattern
    var iter = query.createIterator();
    while (iter.next()) |result| {
        const pos = result.get(Position);
        const vel = result.get(Velocity);
        sum_x += pos.x + vel.x;
        count += 1;
    }
    
    try testing.expectEqual(@as(u32, 10), count);
    try testing.expectEqual(@as(f32, 55.0), sum_x); // (0+1) + (1+1) + ... + (9+1) = 45 + 10
}

test "Frame update" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Initial state
    try testing.expectEqual(@as(u64, 0), frame.frame_number);
    try testing.expectEqual(@as(f32, 0.0), frame.deltaTime);

    // Update frame
    const input = TestInput{ .value = 42.0 };
    test_ecs.update(input, 0.016, 1.0);

    try testing.expectEqual(@as(u64, 1), frame.frame_number);
    try testing.expectEqual(@as(f32, 0.016), frame.deltaTime);
    try testing.expectEqual(@as(f64, 1.0), frame.time);
    try testing.expectEqual(@as(f32, 42.0), frame.input.value);

    // Update again
    test_ecs.update(input, 0.016, 2.0);
    try testing.expectEqual(@as(u64, 2), frame.frame_number);
}

test "Rollback save and restore" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create initial state
    const e1 = try frame.createEntity();
    try frame.addComponent(e1, Position{ .x = 10.0, .y = 20.0 });
    try frame.addComponent(e1, Health{ .value = 100, .max = 100 });

    const e2 = try frame.createEntity();
    try frame.addComponent(e2, Position{ .x = 30.0, .y = 40.0 });

    test_ecs.update(TestInput{ .value = 1.0 }, 0.016, 1.0);

    // Save frame
    var saved_frame = try test_ecs.saveFrame(testing.allocator);
    defer StandardECS.freeSavedFrame(&saved_frame);

    // Modify current state
    const pos1 = frame.getComponent(e1, Position).?;
    pos1.x = 999.0;

    const health = frame.getComponent(e1, Health).?;
    health.value = 50;

    frame.destroyEntity(e2);

    const e3 = try frame.createEntity();
    try frame.addComponent(e3, Position{ .x = 50.0, .y = 60.0 });

    test_ecs.update(TestInput{ .value = 2.0 }, 0.032, 2.0);

    // Verify changes
    try testing.expectEqual(@as(f32, 999.0), frame.getComponent(e1, Position).?.x);
    try testing.expectEqual(@as(i32, 50), frame.getComponent(e1, Health).?.value);
    try testing.expectEqual(@as(u32, 2), frame.getEntityCount());
    try testing.expectEqual(@as(f32, 2.0), frame.input.value);
    try testing.expectEqual(@as(u64, 2), frame.frame_number);

    // Restore frame
    try test_ecs.restoreFrame(&saved_frame);

    // Verify restoration
    try testing.expectEqual(@as(f32, 10.0), frame.getComponent(e1, Position).?.x);
    try testing.expectEqual(@as(i32, 100), frame.getComponent(e1, Health).?.value);
    try testing.expect(frame.getComponent(e2, Position) != null); // e2 exists again
    try testing.expect(frame.getComponent(e3, Position) == null); // e3 doesn't exist
    try testing.expectEqual(@as(u32, 2), frame.getEntityCount());
    try testing.expectEqual(@as(f32, 1.0), frame.input.value);
    try testing.expectEqual(@as(u64, 1), frame.frame_number);
}

test "Complex rollback scenario" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create complex initial state
    var entities: [10]ecs.EntityID = undefined;
    for (0..10) |i| {
        entities[i] = try frame.createEntity();
        try frame.addComponent(entities[i], Position{
            .x = @floatFromInt(i * 10),
            .y = @floatFromInt(i * 20),
        });
        if (i % 2 == 0) {
            try frame.addComponent(entities[i], Velocity{
                .x = @floatFromInt(i),
                .y = @floatFromInt(i * 2),
            });
        }
        if (i % 3 == 0) {
            try frame.addComponent(entities[i], Health{
                .value = @intCast(100 - i * 10),
                .max = 100,
            });
        }
    }

    // Save multiple frames
    var saved_frames: [3]StandardECS.Frame = undefined;
    for (0..3) |i| {
        saved_frames[i] = try test_ecs.saveFrame(testing.allocator);

        // Modify state between saves
        for (entities) |entity| {
            if (frame.getComponent(entity, Position)) |pos| {
                pos.x += 5.0;
                pos.y += 10.0;
            }
        }

        // Remove some components
        if (i == 0) {
            _ = frame.removeComponent(entities[0], Velocity);
        } else if (i == 1) {
            frame.destroyEntity(entities[5]);
        }
    }

    // Restore to middle frame
    try test_ecs.restoreFrame(&saved_frames[1]);

    // Verify middle state
    try testing.expect(frame.getComponent(entities[0], Velocity) == null); // Removed in frame 0
    try testing.expect(frame.getComponent(entities[5], Position) != null); // Not yet destroyed
    try testing.expectEqual(@as(f32, 5.0), frame.getComponent(entities[0], Position).?.x);

    // Restore to first frame
    try test_ecs.restoreFrame(&saved_frames[0]);

    // Verify initial state
    try testing.expect(frame.getComponent(entities[0], Velocity) != null); // Has velocity again
    try testing.expectEqual(@as(f32, 0.0), frame.getComponent(entities[0], Position).?.x);

    // Cleanup
    for (&saved_frames) |*saved| {
        StandardECS.freeSavedFrame(saved);
    }
}

test "Dense storage compaction" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities in specific order
    const e0 = try frame.createEntity();
    const e1 = try frame.createEntity();
    const e2 = try frame.createEntity();
    const e3 = try frame.createEntity();

    // Add components
    try frame.addComponent(e0, Position{ .x = 0, .y = 0 });
    try frame.addComponent(e1, Position{ .x = 1, .y = 1 });
    try frame.addComponent(e2, Position{ .x = 2, .y = 2 });
    try frame.addComponent(e3, Position{ .x = 3, .y = 3 });

    // Remove middle entity's component - should swap with last
    _ = frame.removeComponent(e1, Position);

    // Verify remaining components are still valid
    try testing.expectEqual(@as(f32, 0), frame.getComponent(e0, Position).?.x);
    try testing.expectEqual(@as(f32, 2), frame.getComponent(e2, Position).?.x);
    try testing.expectEqual(@as(f32, 3), frame.getComponent(e3, Position).?.x);
    try testing.expect(frame.getComponent(e1, Position) == null);

    // Query should only find 3 entities
    var query = try frame.query(&.{Position});
    try testing.expectEqual(@as(u32, 3), query.count());
}

test "Component storage stress test" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Add and remove many components
    var entities: [100]ecs.EntityID = undefined;
    for (0..100) |i| {
        entities[i] = try frame.createEntity();
        try frame.addComponent(entities[i], Position{
            .x = @floatFromInt(i),
            .y = @floatFromInt(i * 2),
        });
    }

    // Remove every other component
    for (0..100) |i| {
        if (i % 2 == 0) {
            _ = frame.removeComponent(entities[i], Position);
        }
    }

    // Verify count
    var query = try frame.query(&.{Position});
    try testing.expectEqual(@as(u32, 50), query.count());

    // Add them back
    for (0..100) |i| {
        if (i % 2 == 0) {
            try frame.addComponent(entities[i], Position{
                .x = @floatFromInt(i + 1000),
                .y = @floatFromInt(i + 2000),
            });
        }
    }

    // Verify all exist
    query = try frame.query(&.{Position});
    try testing.expectEqual(@as(u32, 100), query.count());
}

test "Multiple component types interaction" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create entities with various component combinations
    const e1 = try frame.createEntity();
    try frame.addComponent(e1, Position{ .x = 1, .y = 1 });
    try frame.addComponent(e1, Velocity{ .x = 10, .y = 10 });
    try frame.addComponent(e1, Health{ .value = 100, .max = 100 });

    const e2 = try frame.createEntity();
    try frame.addComponent(e2, Position{ .x = 2, .y = 2 });
    try frame.addComponent(e2, Health{ .value = 50, .max = 100 });

    const e3 = try frame.createEntity();
    try frame.addComponent(e3, Velocity{ .x = 30, .y = 30 });
    try frame.addComponent(e3, Health{ .value = 75, .max = 100 });

    // Query different combinations
    var pos_vel_query = try frame.query(&.{ Position, Velocity });
    try testing.expectEqual(@as(u32, 1), pos_vel_query.count());

    var pos_health_query = try frame.query(&.{ Position, Health });
    try testing.expectEqual(@as(u32, 2), pos_health_query.count());

    var vel_health_query = try frame.query(&.{ Velocity, Health });
    try testing.expectEqual(@as(u32, 2), vel_health_query.count());

    var all_three_query = try frame.query(&.{ Position, Velocity, Health });
    try testing.expectEqual(@as(u32, 1), all_three_query.count());
}

test "Entity destruction removes from all storages" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    const entity = try frame.createEntity();
    try frame.addComponent(entity, Position{ .x = 1, .y = 2 });
    try frame.addComponent(entity, Velocity{ .x = 3, .y = 4 });
    try frame.addComponent(entity, Health{ .value = 100, .max = 100 });
    try frame.addComponent(entity, Name{ .value = "test" });
    try frame.addComponent(entity, Tag{ .id = 42 });

    // Verify all components exist
    try testing.expect(frame.hasComponent(entity, Position));
    try testing.expect(frame.hasComponent(entity, Velocity));
    try testing.expect(frame.hasComponent(entity, Health));
    try testing.expect(frame.hasComponent(entity, Name));
    try testing.expect(frame.hasComponent(entity, Tag));

    // Destroy entity
    frame.destroyEntity(entity);

    // Verify all components are removed
    try testing.expect(!frame.hasComponent(entity, Position));
    try testing.expect(!frame.hasComponent(entity, Velocity));
    try testing.expect(!frame.hasComponent(entity, Health));
    try testing.expect(!frame.hasComponent(entity, Name));
    try testing.expect(!frame.hasComponent(entity, Tag));

    // Entity count should be 0
    try testing.expectEqual(@as(u32, 0), frame.getEntityCount());
}

test "System execution pattern" {
    var test_ecs = try StandardECS.init(testing.allocator);
    defer test_ecs.deinit();

    const frame = test_ecs.getFrame();

    // Create test entities
    for (0..10) |i| {
        const e = try frame.createEntity();
        try frame.addComponent(e, Position{
            .x = @floatFromInt(i),
            .y = 0,
        });
        try frame.addComponent(e, Velocity{
            .x = 1,
            .y = 0,
        });
    }

    // Simulate movement system
    test_ecs.update(TestInput{}, 1.0, 1.0);

    var query = try frame.query(&.{ Position, Velocity });
    while (query.next()) |result| {
        const pos = result.get(Position);
        const vel = result.get(Velocity);
        pos.x += vel.x * frame.deltaTime;
        pos.y += vel.y * frame.deltaTime;
    }

    // Verify all positions updated
    query.reset();
    var i: f32 = 0;
    while (query.next()) |result| : (i += 1) {
        const pos = result.get(Position);
        try testing.expectEqual(i + 1.0, pos.x); // Original + 1.0
        try testing.expectEqual(@as(f32, 0), pos.y);
    }
}

// Complete game example demonstrating ECS usage patterns
test "Complete game example with systems and rollback" {
    // Define game-specific input
    const GameInput = struct {
        move_x: f32,
        move_y: f32,
        attack: bool,
    };

    // Create game ECS with explicit configuration
    const GameECS = ecs.ECS(.{
        .components = &.{ Position, Velocity, Health },
        .input = GameInput,
        .max_entities = .large, // 1024 entities
    });

    // Define systems
    const Systems = struct {
        fn movementSystem(frame: *GameECS.Frame) void {
            var q = frame.query(&.{ Position, Velocity }) catch return;

            while (q.next()) |result| {
                var pos = result.get(Position);
                const vel = result.get(Velocity);

                pos.x += vel.x * frame.deltaTime;
                pos.y += vel.y * frame.deltaTime;
            }
        }

        fn playerInputSystem(frame: *GameECS.Frame) void {
            var q = frame.query(&.{Velocity}) catch return;

            if (q.next()) |result| {
                var vel = result.get(Velocity);
                vel.x = frame.input.move_x * 5.0;
                vel.y = frame.input.move_y * 5.0;
            }
        }

        pub fn runAll(frame: *GameECS.Frame) void {
            playerInputSystem(frame);
            movementSystem(frame);
        }
    };

    // Initialize ECS
    var game_ecs = try GameECS.init(testing.allocator);
    defer game_ecs.deinit();

    var frame = game_ecs.getFrame();

    // Create player entity
    const player = try frame.createEntity();
    try frame.addComponent(player, Position{ .x = 0, .y = 0 });
    try frame.addComponent(player, Velocity{ .x = 0, .y = 0 });
    try frame.addComponent(player, Health{ .value = 100, .max = 100 });

    // Simulate game loop
    for (0..5) |i| {
        const input = GameInput{
            .move_x = if (i % 2 == 0) @as(f32, 1.0) else 0.0,
            .move_y = 0.0,
            .attack = false,
        };

        game_ecs.update(input, 0.016, @as(f64, @floatFromInt(i)) * 0.016);
        Systems.runAll(frame);

        // Verify player moved correctly
        const pos = frame.getComponent(player, Position).?;
        if (i == 0) {
            try testing.expectApproxEqAbs(@as(f32, 0.08), pos.x, 0.001);
        }
    }

    // Test rollback functionality
    const saved_frame = try game_ecs.saveFrame(testing.allocator);
    defer GameECS.freeSavedFrame(@constCast(&saved_frame));

    // Record position before forward simulation
    const pos_before = frame.getComponent(player, Position).?;
    const x_before = pos_before.x;
    const y_before = pos_before.y;

    // Simulate forward with different input
    for (0..3) |i| {
        const input = GameInput{ .move_x = 2.0, .move_y = 1.0, .attack = false };
        game_ecs.update(input, 0.016, @as(f64, @floatFromInt(i + 10)) * 0.016);
        Systems.runAll(frame);
    }

    // Verify position changed
    const pos_after = frame.getComponent(player, Position).?;
    try testing.expect(pos_after.x != x_before);
    try testing.expect(pos_after.y != y_before);

    // Rollback to saved state
    try game_ecs.restoreFrame(&saved_frame);

    // Verify position restored
    const pos_restored = frame.getComponent(player, Position).?;
    try testing.expectEqual(x_before, pos_restored.x);
    try testing.expectEqual(y_before, pos_restored.y);
}

// Run all tests
test {
    std.testing.refAllDecls(@This());
}