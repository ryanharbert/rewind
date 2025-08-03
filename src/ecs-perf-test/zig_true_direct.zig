const std = @import("std");

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

const EntityID = u32;
const INVALID_ENTITY: EntityID = std.math.maxInt(EntityID);
const MAX_ENTITIES = 1024;

// Direct access component storage (mimicking C# approach)
fn ComponentStorage(comptime T: type) type {
    return struct {
        const Self = @This();
        
        // Dense array like C# version
        dense: std.ArrayList(T),
        // Bitset tracking which entities have this component
        entity_bitset: std.bit_set.IntegerBitSet(MAX_ENTITIES),
        // Entity to dense index mapping
        entity_to_index: [MAX_ENTITIES]u32,
        // Reverse mapping for removal
        index_to_entity: std.ArrayList(EntityID),
        
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .dense = std.ArrayList(T).init(allocator),
                .entity_bitset = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
                .entity_to_index = [_]u32{0} ** MAX_ENTITIES,
                .index_to_entity = std.ArrayList(EntityID).init(allocator),
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.dense.deinit();
            self.index_to_entity.deinit();
        }
        
        pub fn add(self: *Self, entity: EntityID, component: T) !void {
            if (self.entity_bitset.isSet(entity)) return;
            
            const index = @as(u32, @intCast(self.dense.items.len));
            try self.dense.append(component);
            try self.index_to_entity.append(entity);
            self.entity_to_index[entity] = index;
            self.entity_bitset.set(entity);
        }
        
        // Direct access to dense array element (like C# ref access)
        pub fn getDirect(self: *Self, entity: EntityID) ?*T {
            if (!self.entity_bitset.isSet(entity)) return null;
            const index = self.entity_to_index[entity];
            return &self.dense.items[index];
        }
    };
}

// Direct access ECS (like C# version)
const DirectECS = struct {
    transforms: ComponentStorage(Transform),
    velocities: ComponentStorage(Velocity),
    healths: ComponentStorage(Health),
    active_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
    next_entity: EntityID,
    entity_count: u32,
    deltaTime: f32,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator) Self {
        return Self{
            .transforms = ComponentStorage(Transform).init(allocator),
            .velocities = ComponentStorage(Velocity).init(allocator),
            .healths = ComponentStorage(Health).init(allocator),
            .active_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
            .next_entity = 0,
            .entity_count = 0,
            .deltaTime = 0.0,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.transforms.deinit();
        self.velocities.deinit();
        self.healths.deinit();
    }
    
    pub fn createEntity(self: *Self) !EntityID {
        var entity = self.next_entity;
        while (entity < MAX_ENTITIES and self.active_entities.isSet(entity)) {
            entity += 1;
        }
        
        if (entity >= MAX_ENTITIES) {
            return error.EntityLimitExceeded;
        }
        
        self.active_entities.set(entity);
        self.entity_count += 1;
        self.next_entity = entity + 1;
        
        return entity;
    }
    
    pub fn addTransform(self: *Self, entity: EntityID, component: Transform) !void {
        try self.transforms.add(entity, component);
    }
    
    pub fn addVelocity(self: *Self, entity: EntityID, component: Velocity) !void {
        try self.velocities.add(entity, component);
    }
    
    pub fn addHealth(self: *Self, entity: EntityID, component: Health) !void {
        try self.healths.add(entity, component);
    }
    
    // Query with bitset intersection (like C#)
    pub fn queryTransformVelocity(self: *Self) std.bit_set.IntegerBitSet(MAX_ENTITIES) {
        var result = self.active_entities.intersectWith(self.transforms.entity_bitset);
        return result.intersectWith(self.velocities.entity_bitset);
    }
    
    pub fn queryHealth(self: *Self) std.bit_set.IntegerBitSet(MAX_ENTITIES) {
        return self.active_entities.intersectWith(self.healths.entity_bitset);
    }
    
    pub fn update(self: *Self, deltaTime: f32) void {
        self.deltaTime = deltaTime;
    }
};

// Direct access systems (exactly like C# and Go versions)
fn directUpdateTransformSystem(ecs: *DirectECS) void {
    const query_bitset = ecs.queryTransformVelocity();
    const delta_time = ecs.deltaTime;
    
    // Direct iteration like C# foreach and Go ForEach
    var iterator = query_bitset.iterator(.{});
    while (iterator.next()) |entity_index| {
        const entity = @as(EntityID, @intCast(entity_index));
        
        // Direct pointer access (like C# ref and Go unsafe.Pointer)
        const transform_ptr = ecs.transforms.getDirect(entity);
        const velocity_ptr = ecs.velocities.getDirect(entity);
        
        if (transform_ptr != null and velocity_ptr != null) {
            const transform = transform_ptr.?;
            const velocity = velocity_ptr.?;
            
            // Direct modification (like C# ref access)
            transform.x += velocity.dx * delta_time;
            transform.y += velocity.dy * delta_time;
            transform.rotation += velocity.angular * delta_time;
            
            // Keep rotation in bounds
            if (transform.rotation > 360.0) transform.rotation -= 360.0;
            if (transform.rotation < 0.0) transform.rotation += 360.0;
        }
    }
}

fn directDamageSystem(ecs: *DirectECS) void {
    const query_bitset = ecs.queryHealth();
    
    var iterator = query_bitset.iterator(.{});
    while (iterator.next()) |entity_index| {
        const entity = @as(EntityID, @intCast(entity_index));
        
        const health_ptr = ecs.healths.getDirect(entity);
        
        if (health_ptr != null) {
            const health = health_ptr.?;
            health.current -= 1;
            if (health.current < 0) health.current = health.max;
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Zig Bitset ECS Performance Test (True Direct Access - C# Style) ===\n", .{});
    std.debug.print("Testing with direct component access and bitset iteration\n\n", .{});
    
    // Test different entity counts
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var ecs = DirectECS.init(allocator);
        defer ecs.deinit();
        
        const setup_start = std.time.nanoTimestamp();
        
        var first_entity: EntityID = INVALID_ENTITY;
        
        // Create entities
        for (0..entity_count) |i| {
            const entity = try ecs.createEntity();
            if (i == 0) first_entity = entity;
            
            // All entities get transform
            try ecs.addTransform(entity, Transform{
                .x = @floatFromInt(i % 100),
                .y = @floatFromInt(i / 100),
                .rotation = 0.0,
            });
            
            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                try ecs.addVelocity(entity, Velocity{
                    .dx = @as(f32, @floatFromInt(@as(i32, @intCast(i % 10)) - 5)) * 10.0,
                    .dy = @as(f32, @floatFromInt(@as(i32, @intCast(i % 7)) - 3)) * 10.0,
                    .angular = @as(f32, @floatFromInt(i % 360)),
                });
            }
            
            // 40% get health
            if (i % 5 < 2) {
                try ecs.addHealth(entity, Health{
                    .current = 100,
                    .max = 100,
                });
            }
        }
        
        const setup_time_ns = std.time.nanoTimestamp() - setup_start;
        const setup_time_ms = @as(f64, @floatFromInt(setup_time_ns)) / 1_000_000.0;
        
        // Warm up
        for (0..100) |_| {
            ecs.update(0.016);
            directUpdateTransformSystem(&ecs);
            directDamageSystem(&ecs);
        }
        
        // Get initial values for verification
        const initial_transform_ptr = ecs.transforms.getDirect(first_entity);
        const initial_health_ptr = ecs.healths.getDirect(first_entity);
        
        const initial_x = if (initial_transform_ptr) |t| t.x else -999.0;
        const initial_health_val = if (initial_health_ptr) |h| h.current else -1;
        
        // Benchmark
        const bench_start = std.time.nanoTimestamp();
        
        for (0..frame_count) |_| {
            ecs.update(0.016);
            directUpdateTransformSystem(&ecs);
            directDamageSystem(&ecs);
        }
        
        const bench_time_ns = std.time.nanoTimestamp() - bench_start;
        const bench_time_ms = @as(f64, @floatFromInt(bench_time_ns)) / 1_000_000.0;
        const avg_frame_time_ms = bench_time_ms / @as(f64, @floatFromInt(frame_count));
        
        // Get final values for verification
        const final_transform_ptr = ecs.transforms.getDirect(first_entity);
        const final_health_ptr = ecs.healths.getDirect(first_entity);
        
        const final_x = if (final_transform_ptr) |t| t.x else -999.0;
        const final_health_val = if (final_health_ptr) |h| h.current else -1;
        
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
    
    std.debug.print("\n=== End of Zig True Direct Access Performance Test ===\n", .{});
}