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

// ULTRA FAST: Direct access component storage (exactly like C# version)
fn ComponentStorage(comptime T: type) type {
    return struct {
        const Self = @This();
        
        // Dense array like C# version - direct typed access
        dense: std.ArrayList(T),
        // Bitset tracking which entities have this component
        entity_bitset: std.bit_set.IntegerBitSet(MAX_ENTITIES),
        // Entity to dense index mapping
        entity_to_index: [MAX_ENTITIES]u32,
        
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .dense = std.ArrayList(T).init(allocator),
                .entity_bitset = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
                .entity_to_index = [_]u32{0} ** MAX_ENTITIES,
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.dense.deinit();
        }
        
        pub fn add(self: *Self, entity: EntityID, component: T) !void {
            if (self.entity_bitset.isSet(entity)) return;
            
            const index = @as(u32, @intCast(self.dense.items.len));
            try self.dense.append(component);
            self.entity_to_index[entity] = index;
            self.entity_bitset.set(entity);
        }
        
        // ULTRA FAST: Direct access to dense array element (like C# ref access)
        pub inline fn getDirectUnsafe(self: *Self, entity: EntityID) *T {
            const index = self.entity_to_index[entity];
            return &self.dense.items[index];
        }
    };
}

// ULTRA FAST: Direct access ECS (like C# version)
const UltraFastECS = struct {
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
    
    pub fn update(self: *Self, deltaTime: f32) void {
        self.deltaTime = deltaTime;
    }
};

// ULTRA FAST: Direct access systems with manual bitset operations
fn ultraFastUpdateTransformSystem(ecs: *UltraFastECS) void {
    const delta_time = ecs.deltaTime;
    
    // Manual bitset intersection for maximum speed (like C# bitwise operations)
    const active_words = ecs.active_entities.words;
    const transform_words = ecs.transforms.entity_bitset.words;
    const velocity_words = ecs.velocities.entity_bitset.words;
    
    // Direct word iteration for maximum performance
    for (active_words, transform_words, velocity_words, 0..) |active_word, transform_word, velocity_word, word_index| {
        // Triple intersection in one operation
        var query_word = active_word & transform_word & velocity_word;
        if (query_word == 0) continue;
        
        const base_entity = @as(EntityID, @intCast(word_index * 64));
        
        // Direct bit manipulation (like C# bit operations)
        while (query_word != 0) {
            const bit_index = @ctz(query_word); // Count trailing zeros (like C# TrailingZeroCount)
            const entity = base_entity + bit_index;
            
            // ULTRA FAST: Direct array access without any checks (like C# ref)
            const transform = ecs.transforms.getDirectUnsafe(entity);
            const velocity = ecs.velocities.getDirectUnsafe(entity);
            
            // Direct modification (like C# ref access)
            transform.x += velocity.dx * delta_time;
            transform.y += velocity.dy * delta_time; 
            transform.rotation += velocity.angular * delta_time;
            
            // Keep rotation in bounds
            if (transform.rotation > 360.0) transform.rotation -= 360.0;
            if (transform.rotation < 0.0) transform.rotation += 360.0;
            
            // Clear the processed bit
            query_word &= query_word - 1;
        }
    }
}

fn ultraFastDamageSystem(ecs: *UltraFastECS) void {
    // Manual bitset intersection for maximum speed
    const active_words = ecs.active_entities.words;
    const health_words = ecs.healths.entity_bitset.words;
    
    // Direct word iteration for maximum performance  
    for (active_words, health_words, 0..) |active_word, health_word, word_index| {
        var query_word = active_word & health_word;
        if (query_word == 0) continue;
        
        const base_entity = @as(EntityID, @intCast(word_index * 64));
        
        // Direct bit manipulation
        while (query_word != 0) {
            const bit_index = @ctz(query_word);
            const entity = base_entity + bit_index;
            
            // ULTRA FAST: Direct array access without any checks
            const health = ecs.healths.getDirectUnsafe(entity);
            
            health.current -= 1;
            if (health.current < 0) health.current = health.max;
            
            // Clear the processed bit
            query_word &= query_word - 1;
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Zig Bitset ECS Performance Test (ULTRA FAST - C# Manual Bitset Style) ===\n", .{});
    std.debug.print("Testing with direct component access and manual bitset operations\n\n", .{});
    
    // Test different entity counts
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var ecs = UltraFastECS.init(allocator);
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
            ultraFastUpdateTransformSystem(&ecs);
            ultraFastDamageSystem(&ecs);
        }
        
        // Get initial values for verification
        const initial_transform = ecs.transforms.getDirectUnsafe(first_entity);
        const initial_health = if (ecs.healths.entity_bitset.isSet(first_entity)) ecs.healths.getDirectUnsafe(first_entity) else null;
        
        const initial_x = initial_transform.x;
        const initial_health_val = if (initial_health) |h| h.current else -1;
        
        // Benchmark
        const bench_start = std.time.nanoTimestamp();
        
        for (0..frame_count) |_| {
            ecs.update(0.016);
            ultraFastUpdateTransformSystem(&ecs);
            ultraFastDamageSystem(&ecs);
        }
        
        const bench_time_ns = std.time.nanoTimestamp() - bench_start;
        const bench_time_ms = @as(f64, @floatFromInt(bench_time_ns)) / 1_000_000.0;
        const avg_frame_time_ms = bench_time_ms / @as(f64, @floatFromInt(frame_count));
        
        // Get final values for verification
        const final_transform = ecs.transforms.getDirectUnsafe(first_entity);
        const final_health = if (ecs.healths.entity_bitset.isSet(first_entity)) ecs.healths.getDirectUnsafe(first_entity) else null;
        
        const final_x = final_transform.x;
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
    
    std.debug.print("\n=== End of Zig ULTRA FAST Performance Test ===\n", .{});
}