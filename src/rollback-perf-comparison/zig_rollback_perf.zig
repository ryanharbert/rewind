const std = @import("std");
const ecs = @import("ecs.zig");

// Component types for rollback testing - same as C# version
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

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    
    std.debug.print("=== Zig Rollback Performance Comparison ===\n", .{});
    
    const entity_counts = [_]u32{ 100, 500, 1000 };
    const frame_count = 1000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- {} Entities ---\n", .{entity_count});
        
        var game_ecs = try GameECS.init(allocator);
        defer game_ecs.deinit();
        
        const frame = game_ecs.getFrame();
        
        // Create entities with components
        for (0..entity_count) |i| {
            const entity = try frame.createEntity();
            
            try frame.addComponent(entity, Transform{
                .x = @floatFromInt(i % 100),
                .y = @floatFromInt(i / 100),
                .rotation = 0.0,
            });
            
            // 80% get velocity
            if (i % 5 < 4) {
                try frame.addComponent(entity, Velocity{
                    .dx = @as(f32, @floatFromInt(@as(i32, @intCast(i % 10)) - 5)) * 2.0,
                    .dy = @as(f32, @floatFromInt(@as(i32, @intCast(i % 7)) - 3)) * 2.0,
                    .angular = @as(f32, @floatFromInt(i % 180)),
                });
            }
            
            // 60% get health
            if (i % 5 < 3) {
                try frame.addComponent(entity, Health{
                    .current = 100,
                    .max = 100,
                });
            }
        }
        
        // Test pure copying performance
        var saved_frames = std.ArrayList(GameECS.Frame).init(allocator);
        defer {
            for (saved_frames.items) |*saved_frame| {
                GameECS.freeSavedFrame(saved_frame);
            }
            saved_frames.deinit();
        }
        
        const copy_start = std.time.nanoTimestamp();
        for (0..frame_count) |_| {
            const copied_frame = try game_ecs.saveFrame(allocator);
            try saved_frames.append(copied_frame);
        }
        const copy_time_ns = std.time.nanoTimestamp() - copy_start;
        const copy_time_ms = @as(f64, @floatFromInt(copy_time_ns)) / 1_000_000.0;
        const avg_copy_time_us = (copy_time_ms * 1000.0) / @as(f64, @floatFromInt(frame_count));
        
        // Test restoration performance
        const restore_start = std.time.nanoTimestamp();
        for (0..frame_count) |i| {
            const frame_index = i % saved_frames.items.len;
            try game_ecs.restoreFrame(&saved_frames.items[frame_index]);
        }
        const restore_time_ns = std.time.nanoTimestamp() - restore_start;
        const restore_time_ms = @as(f64, @floatFromInt(restore_time_ns)) / 1_000_000.0;
        const avg_restore_time_us = (restore_time_ms * 1000.0) / @as(f64, @floatFromInt(frame_count));
        
        // Calculate memory usage
        const transform_count = entity_count;
        const velocity_count = (entity_count * 4) / 5;
        const health_count = (entity_count * 3) / 5;
        const total_memory_kb = (@as(f64, @floatFromInt(
            transform_count * @sizeOf(Transform) +
            velocity_count * @sizeOf(Velocity) +
            health_count * @sizeOf(Health) +
            entity_count * @sizeOf(u32) * 2 // entity mappings
        ))) / 1024.0;
        
        std.debug.print("Copy time: {d:.1}μs avg ({d:.2}ms total)\n", .{ avg_copy_time_us, copy_time_ms });
        std.debug.print("Restore time: {d:.1}μs avg ({d:.2}ms total)\n", .{ avg_restore_time_us, restore_time_ms });
        std.debug.print("Memory per frame: ~{d:.1}KB\n", .{total_memory_kb});
        std.debug.print("Components: {} Transform, {} Velocity, {} Health\n", .{ transform_count, velocity_count, health_count });
    }
    
    std.debug.print("\n=== End Zig Rollback Test ===\n", .{});
}