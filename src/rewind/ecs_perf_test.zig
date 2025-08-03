const std = @import("std");
const ecs = @import("ecs.zig");

// Component types matching the optimized test
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

// Input type for ECS
const TestInput = struct {
    deltaTime: f32 = 0.016,
};

// Create generic ECS with same components and entity limit as optimized version
const GenericECS = ecs.ECS(.{
    .components = &.{ Transform, Velocity, Health },
    .input = TestInput,
    .max_entities = .large, // 1024 entities to match optimized test
});

// System implementations using generic ECS
fn updateTransformSystem(frame: *GenericECS.Frame) !void {
    const delta_time = frame.deltaTime;
    
    // Direct storage access for performance
    const transform_storage = frame.getStorage(Transform);
    const velocity_storage = frame.getStorage(Velocity);
    
    // Query for entities with both Transform and Velocity
    var query = try frame.query(&.{ Transform, Velocity });
    
    var iter = query.createIterator();
    while (iter.next()) |result| {
        // Use direct access methods - no safety checks
        const transform = transform_storage.getDirect(result.entity);
        const velocity = velocity_storage.getDirect(result.entity);
        
        // Update transform
        transform.x += velocity.dx * delta_time;
        transform.y += velocity.dy * delta_time;
        transform.rotation += velocity.angular * delta_time;
        
        // Keep rotation in bounds
        if (transform.rotation > 360.0) {
            transform.rotation -= 360.0;
        } else if (transform.rotation < 0.0) {
            transform.rotation += 360.0;
        }
    }
}

fn damageSystem(frame: *GenericECS.Frame) !void {
    // Direct storage access for performance
    const health_storage = frame.getStorage(Health);
    
    // Query for entities with Health
    var query = try frame.query(&.{Health});
    
    var iter = query.createIterator();
    while (iter.next()) |result| {
        // Use direct access method - no safety checks
        const health = health_storage.getDirect(result.entity);
        
        health.current -= 1;
        if (health.current < 0) {
            health.current = health.max;
        }
    }
}

pub fn main() !void {
    // Use general purpose allocator for now
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Generic ECS Performance Test (Using rewind/ecs.zig) ===\n", .{});
    std.debug.print("Testing with standard generic ECS implementation\n\n", .{});
    
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var generic_ecs = try GenericECS.init(allocator);
        defer generic_ecs.deinit();
        
        const frame = generic_ecs.getFrame();
        
        const setup_start = std.time.nanoTimestamp();
        
        var first_entity: ?ecs.EntityID = null;
        
        // Create entities
        for (0..entity_count) |i| {
            const entity = try frame.createEntity();
            if (i == 0) first_entity = entity;
            
            // All entities get transform
            try frame.addComponent(entity, Transform{
                .x = @floatFromInt(i % 100),
                .y = @floatFromInt(i / 100),
                .rotation = 0.0,
            });
            
            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                try frame.addComponent(entity, Velocity{
                    .dx = @as(f32, @floatFromInt(@as(i32, @intCast(i % 10)) - 5)) * 10.0,
                    .dy = @as(f32, @floatFromInt(@as(i32, @intCast(i % 7)) - 3)) * 10.0,
                    .angular = @as(f32, @floatFromInt(i % 360)),
                });
            }
            
            // 40% get health
            if (i % 5 < 2) {
                try frame.addComponent(entity, Health{
                    .current = 100,
                    .max = 100,
                });
            }
        }
        
        const setup_time_ns = std.time.nanoTimestamp() - setup_start;
        const setup_time_ms = @as(f64, @floatFromInt(setup_time_ns)) / 1_000_000.0;
        
        // Warm up
        for (0..100) |_| {
            generic_ecs.update(.{ .deltaTime = 0.016 }, 0.016, 0.0);
            try updateTransformSystem(frame);
            try damageSystem(frame);
        }
        
        // Get initial values for verification
        const initial_transform = if (first_entity) |e| frame.getComponent(e, Transform) else null;
        const initial_health = if (first_entity) |e| frame.getComponent(e, Health) else null;
        
        const initial_x = if (initial_transform) |t| t.x else -999.0;
        const initial_health_val = if (initial_health) |h| h.current else -1;
        
        // Benchmark
        const bench_start = std.time.nanoTimestamp();
        
        for (0..frame_count) |_| {
            generic_ecs.update(.{ .deltaTime = 0.016 }, 0.016, 0.0);
            try updateTransformSystem(frame);
            try damageSystem(frame);
        }
        
        const bench_time_ns = std.time.nanoTimestamp() - bench_start;
        const bench_time_ms = @as(f64, @floatFromInt(bench_time_ns)) / 1_000_000.0;
        const avg_frame_time_ms = bench_time_ms / @as(f64, @floatFromInt(frame_count));
        
        // Get final values for verification
        const final_transform = if (first_entity) |e| frame.getComponent(e, Transform) else null;
        const final_health = if (first_entity) |e| frame.getComponent(e, Health) else null;
        
        const final_x = if (final_transform) |t| t.x else -999.0;
        const final_health_val = if (final_health) |h| h.current else -1;
        
        std.debug.print("Setup time: {d:.2}ms\n", .{setup_time_ms});
        std.debug.print("Total benchmark time: {d:.2}ms\n", .{bench_time_ms});
        std.debug.print("Average frame time: {d:.3}ms\n", .{avg_frame_time_ms});
        std.debug.print("FPS: {d:.1}\n", .{1000.0 / avg_frame_time_ms});
        
        // Verification
        std.debug.print("Transform verification - Initial X: {d:.2}, Final X: {d:.2}, Delta: {d:.2}\n", .{ initial_x, final_x, final_x - initial_x });
        if (initial_health_val >= 0) {
            std.debug.print("Health verification - Initial: {}, Final: {}\n", .{ initial_health_val, final_health_val });
        }
    }
    
    std.debug.print("\n=== End of Generic ECS Performance Test ===\n", .{});
}