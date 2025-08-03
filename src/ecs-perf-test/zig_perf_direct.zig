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

// Direct access system (mimicking C# approach)
fn directUpdateTransformSystem(frame: *PerfECS.Frame) !void {
    // Get the bitset of entities with both Transform and Velocity
    var query = try frame.query(&.{ Transform, Velocity });
    const delta_time = frame.deltaTime;
    
    // Here's the key insight: we need to access the ECS internals
    // Unfortunately, the current Zig ECS doesn't expose the dense arrays
    // So let's use the query but minimize overhead
    
    // Reset query and iterate
    query.reset();
    while (query.next()) |result| {
        // Direct pointer access - no function call overhead
        const entity = result.entity;
        const transform_ptr = frame.state.getComponent(entity, Transform).?;
        const velocity_ptr = frame.state.getComponent(entity, Velocity).?;
        
        // Direct modification (equivalent to C# ref access)
        transform_ptr.x += velocity_ptr.dx * delta_time;
        transform_ptr.y += velocity_ptr.dy * delta_time;
        transform_ptr.rotation += velocity_ptr.angular * delta_time;
        
        // Keep rotation in bounds
        if (transform_ptr.rotation > 360.0) transform_ptr.rotation -= 360.0;
        if (transform_ptr.rotation < 0.0) transform_ptr.rotation += 360.0;
    }
}

fn directDamageSystem(frame: *PerfECS.Frame) !void {
    var query = try frame.query(&.{Health});
    
    query.reset();
    while (query.next()) |result| {
        const entity = result.entity;
        const health_ptr = frame.state.getComponent(entity, Health).?;
        
        health_ptr.current -= 1;
        if (health_ptr.current < 0) health_ptr.current = health_ptr.max;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Zig Bitset ECS Performance Test (Direct Access) ===\n", .{});
    std.debug.print("Testing with direct component access (C# equivalent)\n\n", .{});
    
    // Test different entity counts
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var perf_ecs = try PerfECS.init(allocator);
        defer perf_ecs.deinit();
        
        const setup_start = std.time.nanoTimestamp();
        
        var first_entity: ecs.EntityID = ecs.INVALID_ENTITY;
        
        for (0..entity_count) |i| {
            const entity = try perf_ecs.current_frame.createEntity();
            if (i == 0) first_entity = entity;
            
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
        
        const setup_time_ns = std.time.nanoTimestamp() - setup_start;
        const setup_time_ms = @as(f64, @floatFromInt(setup_time_ns)) / 1_000_000.0;
        
        // Warm up
        for (0..100) |_| {
            perf_ecs.update(TestInput{ .deltaTime = 0.016 }, 0.016, 0.0);
            try directUpdateTransformSystem(&perf_ecs.current_frame);
            try directDamageSystem(&perf_ecs.current_frame);
        }
        
        // Get initial values for verification
        const initial_transform = perf_ecs.current_frame.getComponent(first_entity, Transform);
        const initial_health = perf_ecs.current_frame.getComponent(first_entity, Health);
        
        const initial_x = if (initial_transform) |t| t.x else -999.0;
        const initial_health_val = if (initial_health) |h| h.current else -1;
        
        // Benchmark
        const bench_start = std.time.nanoTimestamp();
        
        for (0..frame_count) |frame_num| {
            perf_ecs.update(TestInput{ .deltaTime = 0.016 }, 0.016, @as(f64, @floatFromInt(frame_num)) * 0.016);
            try directUpdateTransformSystem(&perf_ecs.current_frame);
            try directDamageSystem(&perf_ecs.current_frame);
        }
        
        const bench_time_ns = std.time.nanoTimestamp() - bench_start;
        const bench_time_ms = @as(f64, @floatFromInt(bench_time_ns)) / 1_000_000.0;
        const avg_frame_time_ms = bench_time_ms / @as(f64, @floatFromInt(frame_count));
        
        // Get final values for verification
        const final_transform = perf_ecs.current_frame.getComponent(first_entity, Transform);
        const final_health = perf_ecs.current_frame.getComponent(first_entity, Health);
        
        const final_x = if (final_transform) |t| t.x else -999.0;
        const final_health_val = if (final_health) |h| h.current else -1;
        
        // Count entities with each component for verification
        var transform_query = try perf_ecs.current_frame.query(&.{Transform});
        const transform_count = transform_query.count();
        
        var velocity_query = try perf_ecs.current_frame.query(&.{Velocity});
        const velocity_count = velocity_query.count();
        
        var health_query = try perf_ecs.current_frame.query(&.{Health});
        const health_count = health_query.count();
        
        std.debug.print("Setup time: {d:.2}ms\n", .{setup_time_ms});
        std.debug.print("Total benchmark time: {d:.2}ms\n", .{bench_time_ms});
        std.debug.print("Average frame time: {d:.3}ms\n", .{avg_frame_time_ms});
        std.debug.print("FPS: {d:.1}\n", .{1000.0 / avg_frame_time_ms});
        std.debug.print("Entities - Transform: {}, Velocity: {}, Health: {}\n", .{ transform_count, velocity_count, health_count });
        
        // Verification output
        std.debug.print("Transform verification - Initial X: {d:.2}, Final X: {d:.2}, Delta: {d:.2}\n", .{ initial_x, final_x, final_x - initial_x });
        if (initial_health_val >= 0) {
            std.debug.print("Health verification - Initial: {}, Final: {}\n", .{ initial_health_val, final_health_val });
        }
    }
    
    std.debug.print("\n=== End of Zig Direct Access Performance Test ===\n", .{});
}