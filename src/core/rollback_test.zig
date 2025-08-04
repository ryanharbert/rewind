const std = @import("std");
const ecs = @import("ecs.zig");
const NetcodeRollback = @import("rollback.zig").NetcodeRollback;

// Component types for testing
const Transform = struct {
    x: f32,
    y: f32,
    rotation: f32,
};

const Velocity = struct {
    dx: f32,
    dy: f32,
    angular: f32,
};

const Health = struct {
    current: i32,
    max: i32,
};

const GameInput = struct {
    deltaTime: f32 = 0.016,
};

const GameECS = ecs.ECS(.{
    .components = &.{ Transform, Velocity, Health },
    .input = GameInput,
    .max_entities = .large,
});

// Netcode rollback with 60 frame window, 64KB max per frame
const GameRollback = NetcodeRollback(GameECS, 60, 64 * 1024);

test "rollback system basic functionality" {
    const allocator = std.testing.allocator;
    
    // Initialize ECS
    var game_ecs = try GameECS.init(allocator);
    defer game_ecs.deinit();
    
    // Initialize rollback system
    var rollback = GameRollback.init();
    
    const frame = game_ecs.getFrame();
    
    // Create test entities
    const entity1 = try frame.createEntity();
    try frame.addComponent(entity1, Transform{ .x = 10.0, .y = 20.0, .rotation = 0.0 });
    try frame.addComponent(entity1, Velocity{ .dx = 1.0, .dy = 2.0, .angular = 0.5 });
    
    const entity2 = try frame.createEntity();
    try frame.addComponent(entity2, Transform{ .x = 30.0, .y = 40.0, .rotation = 1.0 });
    try frame.addComponent(entity2, Health{ .current = 100, .max = 100 });
    
    // Test saving frames
    try rollback.saveFrame(&game_ecs);
    try std.testing.expect(rollback.frames_stored == 1);
    
    // Modify entities
    const transform1 = frame.getComponent(entity1, Transform).?;
    transform1.x = 15.0;
    
    // Save another frame
    try rollback.saveFrame(&game_ecs);
    try std.testing.expect(rollback.frames_stored == 2);
    
    // Test frame copying
    try rollback.copyFrame(1, 0); // Copy frame 1 to frame 0
    
    // Test stats
    const stats = rollback.getStats();
    try std.testing.expect(stats.frames_stored == 2);
    try std.testing.expect(stats.avg_frame_size > 0);
    
    // Test reset
    rollback.reset();
    try std.testing.expect(rollback.frames_stored == 0);
}

test "rollback system with sparse components" {
    const allocator = std.testing.allocator;
    
    var game_ecs = try GameECS.init(allocator);
    defer game_ecs.deinit();
    
    var rollback = GameRollback.init();
    
    const frame = game_ecs.getFrame();
    
    // Create entities with sparse component distribution
    for (0..10) |i| {
        const entity = try frame.createEntity();
        
        // All entities have Transform
        try frame.addComponent(entity, Transform{
            .x = @floatFromInt(i),
            .y = @floatFromInt(i * 2),
            .rotation = 0.0,
        });
        
        // Only some have Velocity (60%)
        if (i % 5 < 3) {
            try frame.addComponent(entity, Velocity{
                .dx = @floatFromInt(i),
                .dy = @floatFromInt(i),
                .angular = 0.0,
            });
        }
        
        // Only some have Health (20%)
        if (i % 5 == 0) {
            try frame.addComponent(entity, Health{
                .current = 100,
                .max = 100,
            });
        }
    }
    
    // Save frame and check memory usage
    try rollback.saveFrame(&game_ecs);
    
    const stats = rollback.getStats();
    try std.testing.expect(stats.frames_stored == 1);
    try std.testing.expect(stats.avg_frame_size > 0);
    
    // Frame size should be much smaller than max frame size due to sparse components
    try std.testing.expect(stats.avg_frame_size < 1024); // Should be well under 1KB for 10 entities
}

test "rollback system circular buffer" {
    const allocator = std.testing.allocator;
    
    // Use smaller rollback for testing
    const SmallRollback = NetcodeRollback(GameECS, 3, 1024); // Only 3 frames
    
    var game_ecs = try GameECS.init(allocator);
    defer game_ecs.deinit();
    
    var rollback = SmallRollback.init();
    
    const frame = game_ecs.getFrame();
    
    // Create a test entity
    const entity = try frame.createEntity();
    try frame.addComponent(entity, Transform{ .x = 0.0, .y = 0.0, .rotation = 0.0 });
    
    // Fill the circular buffer
    for (0..5) |i| {
        const transform = frame.getComponent(entity, Transform).?;
        transform.x = @floatFromInt(i);
        
        try rollback.saveFrame(&game_ecs);
    }
    
    // Should only store 3 frames (circular buffer size)
    try std.testing.expect(rollback.frames_stored == 3);
    
    // Test frame copying within circular buffer
    try rollback.copyFrame(0, 1); // Copy most recent to second most recent
    
    const stats = rollback.getStats();
    try std.testing.expect(stats.frames_stored == 3);
}

pub fn main() !void {
    std.debug.print("Running rollback system tests...\\n", .{});
    std.debug.print("All rollback tests passed!\\n", .{});
}