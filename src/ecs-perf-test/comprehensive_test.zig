const std = @import("std");
const ecs = @import("ecs");

// Component types
const Transform = struct { x: f32, y: f32, rotation: f32 };
const Velocity = struct { dx: f32, dy: f32, angular: f32 };
const Health = struct { current: i32, max: i32 };
const Collider = struct { radius: f32, layer: u8 };
const AI = struct { state: u8, target: ecs.EntityID };
const Renderable = struct { sprite_id: u32, z_order: i16 };

// Input type
const TestInput = struct {
    deltaTime: f32 = 0.016,
};

// Create ECS with more components
const ComprehensiveECS = ecs.ECS(.{
    .components = &.{ Transform, Velocity, Health, Collider, AI, Renderable },
    .input = TestInput,
    .max_entities = .large,
});

// Test scenarios
const TestScenario = struct {
    name: []const u8,
    setup: *const fn (frame: *ComprehensiveECS.Frame, entity_count: u32) anyerror!void,
    systems: []const *const fn (frame: *ComprehensiveECS.Frame) anyerror!void,
};

// Scenario 1: Heavy Query Test - Many small queries
fn setupHeavyQuery(frame: *ComprehensiveECS.Frame, entity_count: u32) !void {
    for (0..entity_count) |i| {
        const entity = try frame.createEntity();
        try frame.addComponent(entity, Transform{ .x = @floatFromInt(i), .y = 0, .rotation = 0 });
        
        // Diverse component distribution
        if (i % 2 == 0) try frame.addComponent(entity, Velocity{ .dx = 1, .dy = 0, .angular = 0 });
        if (i % 3 == 0) try frame.addComponent(entity, Health{ .current = 100, .max = 100 });
        if (i % 4 == 0) try frame.addComponent(entity, Collider{ .radius = 10, .layer = 1 });
        if (i % 5 == 0) try frame.addComponent(entity, AI{ .state = 0, .target = ecs.INVALID_ENTITY });
        if (i % 6 == 0) try frame.addComponent(entity, Renderable{ .sprite_id = @intCast(i), .z_order = 0 });
    }
}

fn heavyQuerySystem(frame: *ComprehensiveECS.Frame) !void {
    // Multiple different queries per frame
    var q1 = try frame.query(&.{ Transform, Velocity });
    while (q1.next()) |_| {}
    
    var q2 = try frame.query(&.{ Transform, Health, Collider });
    while (q2.next()) |_| {}
    
    var q3 = try frame.query(&.{ Transform, AI });
    while (q3.next()) |_| {}
    
    var q4 = try frame.query(&.{ Transform, Renderable });
    while (q4.next()) |_| {}
    
    var q5 = try frame.query(&.{ Velocity, Collider, Health });
    while (q5.next()) |_| {}
}

// Scenario 2: Cache Miss Test - Random access patterns
fn setupCacheMiss(frame: *ComprehensiveECS.Frame, entity_count: u32) !void {
    for (0..entity_count) |i| {
        const entity = try frame.createEntity();
        try frame.addComponent(entity, Transform{ .x = @floatFromInt(i), .y = 0, .rotation = 0 });
        try frame.addComponent(entity, Velocity{ .dx = 1, .dy = 0, .angular = 0 });
        if (i % 3 == 0) try frame.addComponent(entity, Health{ .current = 100, .max = 100 });
    }
}

fn cacheMissSystem(frame: *ComprehensiveECS.Frame) !void {
    var query = try frame.query(&.{ Transform, Velocity });
    var prng = std.Random.DefaultPrng.init(42);
    const random = prng.random();
    
    while (query.next()) |result| {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        
        // Simulate random memory access patterns
        const jump = random.intRangeAtMost(u8, 0, 10);
        for (0..jump) |_| {
            transform.x += velocity.dx * 0.001;
            transform.y += velocity.dy * 0.001;
        }
    }
}

// Scenario 3: Component Add/Remove Test
fn setupDynamic(frame: *ComprehensiveECS.Frame, entity_count: u32) !void {
    for (0..entity_count) |i| {
        const entity = try frame.createEntity();
        try frame.addComponent(entity, Transform{ .x = @floatFromInt(i), .y = 0, .rotation = 0 });
    }
}

fn dynamicSystem(frame: *ComprehensiveECS.Frame) !void {
    var query = try frame.query(&.{Transform});
    var count: u32 = 0;
    
    while (query.next()) |result| {
        // Add/remove components dynamically
        if (count % 10 == 0) {
            if (!frame.hasComponent(result.entity, Velocity)) {
                try frame.addComponent(result.entity, Velocity{ .dx = 1, .dy = 1, .angular = 0 });
            } else {
                _ = frame.removeComponent(result.entity, Velocity);
            }
        }
        count += 1;
    }
}

// Scenario 4: Simple Transform Update (baseline)
fn setupBaseline(frame: *ComprehensiveECS.Frame, entity_count: u32) !void {
    for (0..entity_count) |i| {
        const entity = try frame.createEntity();
        try frame.addComponent(entity, Transform{ .x = @floatFromInt(i), .y = 0, .rotation = 0 });
        try frame.addComponent(entity, Velocity{ .dx = 1, .dy = 1, .angular = 1 });
    }
}

fn baselineSystem(frame: *ComprehensiveECS.Frame) !void {
    var query = try frame.query(&.{ Transform, Velocity });
    while (query.next()) |result| {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        transform.x += velocity.dx * frame.deltaTime;
        transform.y += velocity.dy * frame.deltaTime;
        transform.rotation += velocity.angular * frame.deltaTime;
    }
}

fn runScenario(allocator: std.mem.Allocator, scenario: TestScenario, entity_count: u32, frame_count: u32) !void {
    std.debug.print("\n  Scenario: {s}\n", .{scenario.name});
    
    var test_ecs = try ComprehensiveECS.init(allocator);
    defer test_ecs.deinit();
    
    // Setup
    const setup_start = std.time.milliTimestamp();
    try scenario.setup(&test_ecs.current_frame, entity_count);
    const setup_time = std.time.milliTimestamp() - setup_start;
    
    // Warmup
    for (0..100) |_| {
        test_ecs.update(TestInput{}, 0.016, 0.0);
        for (scenario.systems) |system| {
            try system(&test_ecs.current_frame);
        }
    }
    
    // Benchmark
    const bench_start = std.time.milliTimestamp();
    for (0..frame_count) |_| {
        test_ecs.update(TestInput{}, 0.016, 0.0);
        for (scenario.systems) |system| {
            try system(&test_ecs.current_frame);
        }
    }
    const bench_time = std.time.milliTimestamp() - bench_start;
    const avg_frame_time = @as(f64, @floatFromInt(bench_time)) / @as(f64, @floatFromInt(frame_count));
    
    std.debug.print("    Setup: {}ms, Total: {}ms, Avg frame: {d:.3}ms, FPS: {d:.1}\n", 
        .{ setup_time, bench_time, avg_frame_time, 1000.0 / avg_frame_time });
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Comprehensive ECS Performance Test (Zig) ===\n", .{});
    
    const scenarios = [_]TestScenario{
        .{ .name = "Baseline (Transform+Velocity)", .setup = setupBaseline, .systems = &.{baselineSystem} },
        .{ .name = "Heavy Queries (5 different queries)", .setup = setupHeavyQuery, .systems = &.{heavyQuerySystem} },
        .{ .name = "Cache Miss Pattern", .setup = setupCacheMiss, .systems = &.{cacheMissSystem} },
        .{ .name = "Dynamic Add/Remove", .setup = setupDynamic, .systems = &.{dynamicSystem} },
    };
    
    const entity_counts = [_]u32{ 100, 500, 1000 };
    const frame_count = 5000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- {} Entities, {} Frames ---\n", .{ entity_count, frame_count });
        
        for (scenarios) |scenario| {
            try runScenario(allocator, scenario, entity_count, frame_count);
        }
    }
    
    std.debug.print("\n=== End of Comprehensive Test ===\n", .{});
}