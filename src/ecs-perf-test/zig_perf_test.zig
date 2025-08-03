const std = @import("std");
const ecs = @import("ecs");

// Component types for performance testing
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

// Input type
const TestInput = struct {
    deltaTime: f32 = 0.016,
};

// Create ECS with our components
const PerfECS = ecs.ECS(.{
    .components = &.{ Transform, Velocity, Health },
    .input = TestInput,
    .max_entities = .large, // 1024 entities
});

// System that updates transforms based on velocity
fn updateTransformSystem(frame: *PerfECS.Frame) !void {
    var query = try frame.query(&.{ Transform, Velocity });
    
    while (query.next()) |result| {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        
        // Update position
        transform.x += velocity.dx * frame.deltaTime;
        transform.y += velocity.dy * frame.deltaTime;
        transform.rotation += velocity.angular * frame.deltaTime;
        
        // Keep rotation in bounds
        if (transform.rotation > 360.0) transform.rotation -= 360.0;
        if (transform.rotation < 0.0) transform.rotation += 360.0;
    }
}

// System that applies damage over time
fn damageSystem(frame: *PerfECS.Frame) !void {
    var query = try frame.query(&.{Health});
    
    while (query.next()) |result| {
        const health = result.get(Health);
        health.current -= 1;
        if (health.current < 0) health.current = health.max;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Zig Bitset ECS Performance Test ===\n", .{});
    std.debug.print("Testing with transform updates and damage system\n\n", .{});
    
    // Test different entity counts
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000; // Number of frames to simulate
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        // Initialize ECS
        var perf_ecs = try PerfECS.init(allocator);
        defer perf_ecs.deinit();
        
        const setup_start = std.time.milliTimestamp();
        
        // Create entities
        for (0..entity_count) |i| {
            const entity = try perf_ecs.current_frame.createEntity();
            
            // All entities get transform
            try perf_ecs.current_frame.addComponent(entity, Transform{
                .x = @floatFromInt(i % 100),
                .y = @floatFromInt(i / 100),
                .rotation = 0.0,
            });
            
            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                try perf_ecs.current_frame.addComponent(entity, Velocity{
                    .dx = @as(f32, @floatFromInt(@as(i32, @intCast(i % 10)) - 5)) * 10.0,
                    .dy = @as(f32, @floatFromInt(@as(i32, @intCast(i % 7)) - 3)) * 10.0,
                    .angular = @as(f32, @floatFromInt(i % 360)),
                });
            }
            
            // 40% get health
            if (i % 5 < 2) {
                try perf_ecs.current_frame.addComponent(entity, Health{
                    .current = 100,
                    .max = 100,
                });
            }
        }
        
        const setup_time = std.time.milliTimestamp() - setup_start;
        
        // Warm up
        for (0..100) |_| {
            perf_ecs.update(TestInput{ .deltaTime = 0.016 }, 0.016, 0.0);
            try updateTransformSystem(&perf_ecs.current_frame);
            try damageSystem(&perf_ecs.current_frame);
        }
        
        // Benchmark
        const bench_start = std.time.milliTimestamp();
        
        for (0..frame_count) |frame_num| {
            perf_ecs.update(TestInput{ .deltaTime = 0.016 }, 0.016, @as(f64, @floatFromInt(frame_num)) * 0.016);
            try updateTransformSystem(&perf_ecs.current_frame);
            try damageSystem(&perf_ecs.current_frame);
        }
        
        const bench_time = std.time.milliTimestamp() - bench_start;
        const avg_frame_time = @as(f64, @floatFromInt(bench_time)) / @as(f64, @floatFromInt(frame_count));
        
        // Count entities with each component for verification
        var transform_query = try perf_ecs.current_frame.query(&.{Transform});
        const transform_count = transform_query.count();
        
        var velocity_query = try perf_ecs.current_frame.query(&.{Velocity});
        const velocity_count = velocity_query.count();
        
        var health_query = try perf_ecs.current_frame.query(&.{Health});
        const health_count = health_query.count();
        
        std.debug.print("Setup time: {}ms\n", .{setup_time});
        std.debug.print("Total benchmark time: {}ms\n", .{bench_time});
        std.debug.print("Average frame time: {d:.3}ms\n", .{avg_frame_time});
        std.debug.print("FPS: {d:.1}\n", .{1000.0 / avg_frame_time});
        std.debug.print("Entities - Transform: {}, Velocity: {}, Health: {}\n", .{ transform_count, velocity_count, health_count });
    }
    
    std.debug.print("\n=== End of Zig Performance Test ===\n", .{});
}