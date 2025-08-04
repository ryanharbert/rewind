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

// Optimized bitset implementation
const BitSet = struct {
    size: u32,
    words: []u64,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, size: u32) !Self {
        const word_count = (size + 63) / 64;
        const words = try allocator.alloc(u64, word_count);
        @memset(words, 0);
        return Self{
            .size = size,
            .words = words,
        };
    }
    
    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        allocator.free(self.words);
    }
    
    pub fn clear(self: *Self) void {
        @memset(self.words, 0);
    }
    
    pub inline fn set(self: *Self, index: u32) void {
        if (index >= self.size) return;
        const word_index = index >> 6; // div 64
        const bit_index = @as(u6, @intCast(index & 63)); // mod 64
        self.words[word_index] |= @as(u64, 1) << bit_index;
    }
    
    pub inline fn unset(self: *Self, index: u32) void {
        if (index >= self.size) return;
        const word_index = index >> 6;
        const bit_index = @as(u6, @intCast(index & 63));
        self.words[word_index] &= ~(@as(u64, 1) << bit_index);
    }
    
    pub inline fn isSet(self: *const Self, index: u32) bool {
        if (index >= self.size) return false;
        const word_index = index >> 6;
        const bit_index = @as(u6, @intCast(index & 63));
        return (self.words[word_index] & (@as(u64, 1) << bit_index)) != 0;
    }
    
    // In-place intersection (no allocation)
    pub fn intersectInto(self: *const Self, other: *const Self, result: *Self) void {
        const min_len = @min(self.words.len, other.words.len);
        
        // Use vector operations if available
        var i: usize = 0;
        while (i < min_len) : (i += 1) {
            result.words[i] = self.words[i] & other.words[i];
        }
        
        // Clear remaining words
        while (i < result.words.len) : (i += 1) {
            result.words[i] = 0;
        }
    }
    
    // Copy bitset
    pub fn copyFrom(self: *Self, other: *const Self) void {
        @memcpy(self.words[0..@min(self.words.len, other.words.len)], other.words[0..@min(self.words.len, other.words.len)]);
    }
};

// Optimized component storage
fn ComponentStorage(comptime T: type) type {
    return struct {
        const Self = @This();
        
        // Dense array storage
        dense: []T,
        entity_bitset: BitSet,
        entity_to_index: []u32,
        index_to_entity: []u32,
        count: u32,
        capacity: u32,
        
        pub fn init(allocator: std.mem.Allocator) !Self {
            const initial_capacity = 64;
            return Self{
                .dense = try allocator.alloc(T, initial_capacity),
                .entity_bitset = try BitSet.init(allocator, MAX_ENTITIES),
                .entity_to_index = try allocator.alloc(u32, MAX_ENTITIES),
                .index_to_entity = try allocator.alloc(u32, initial_capacity),
                .count = 0,
                .capacity = initial_capacity,
            };
        }
        
        pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
            allocator.free(self.dense);
            self.entity_bitset.deinit(allocator);
            allocator.free(self.entity_to_index);
            allocator.free(self.index_to_entity);
        }
        
        pub inline fn add(self: *Self, entity: u32, component: T, allocator: std.mem.Allocator) !void {
            if (self.entity_bitset.isSet(entity)) return;
            
            if (self.count >= self.capacity) {
                self.capacity *= 2;
                self.dense = try allocator.realloc(self.dense, self.capacity);
                self.index_to_entity = try allocator.realloc(self.index_to_entity, self.capacity);
            }
            
            const index = self.count;
            self.dense[index] = component;
            self.index_to_entity[index] = entity;
            self.entity_to_index[entity] = index;
            self.entity_bitset.set(entity);
            self.count += 1;
        }
        
        pub inline fn get(self: *Self, entity: u32) ?*T {
            if (!self.entity_bitset.isSet(entity)) return null;
            const index = self.entity_to_index[entity];
            return &self.dense[index];
        }
        
        pub inline fn has(self: *const Self, entity: u32) bool {
            return self.entity_bitset.isSet(entity);
        }
    };
}

// Optimized ECS
const OptimizedECS = struct {
    transforms: ComponentStorage(Transform),
    velocities: ComponentStorage(Velocity),
    healths: ComponentStorage(Health),
    active_entities: BitSet,
    
    // Pre-allocated query bitsets
    query_result: BitSet,
    query_temp: BitSet,
    
    next_entity: u32,
    entity_count: u32,
    delta_time: f32,
    allocator: std.mem.Allocator,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator) !Self {
        return Self{
            .transforms = try ComponentStorage(Transform).init(allocator),
            .velocities = try ComponentStorage(Velocity).init(allocator),
            .healths = try ComponentStorage(Health).init(allocator),
            .active_entities = try BitSet.init(allocator, MAX_ENTITIES),
            .query_result = try BitSet.init(allocator, MAX_ENTITIES),
            .query_temp = try BitSet.init(allocator, MAX_ENTITIES),
            .next_entity = 0,
            .entity_count = 0,
            .delta_time = 0.0,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.transforms.deinit(self.allocator);
        self.velocities.deinit(self.allocator);
        self.healths.deinit(self.allocator);
        self.active_entities.deinit(self.allocator);
        self.query_result.deinit(self.allocator);
        self.query_temp.deinit(self.allocator);
    }
    
    pub fn createEntity(self: *Self) !u32 {
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
    
    pub inline fn addTransform(self: *Self, entity: u32, component: Transform) !void {
        try self.transforms.add(entity, component, self.allocator);
    }
    
    pub inline fn addVelocity(self: *Self, entity: u32, component: Velocity) !void {
        try self.velocities.add(entity, component, self.allocator);
    }
    
    pub inline fn addHealth(self: *Self, entity: u32, component: Health) !void {
        try self.healths.add(entity, component, self.allocator);
    }
    
    pub fn update(self: *Self, delta_time: f32) void {
        self.delta_time = delta_time;
    }
};

// Optimized systems with inline iteration
fn updateTransformSystem(ecs: *OptimizedECS) void {
    const delta_time = ecs.delta_time;
    
    // In-place query computation (no allocations)
    ecs.active_entities.intersectInto(&ecs.transforms.entity_bitset, &ecs.query_result);
    ecs.query_result.intersectInto(&ecs.velocities.entity_bitset, &ecs.query_temp);
    
    // Direct iteration over bitset words
    const words = ecs.query_temp.words;
    for (words, 0..) |word, word_index| {
        if (word == 0) continue;
        
        var current_word = word;
        const base_index = @as(u32, @intCast(word_index * 64));
        
        while (current_word != 0) {
            const bit_index = @ctz(current_word);
            const entity = base_index + bit_index;
            
            // Direct component access (guaranteed to exist)
            const transform = &ecs.transforms.dense[ecs.transforms.entity_to_index[entity]];
            const velocity = &ecs.velocities.dense[ecs.velocities.entity_to_index[entity]];
            
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
            
            current_word &= current_word - 1; // Clear lowest bit
        }
    }
}

fn damageSystem(ecs: *OptimizedECS) void {
    // In-place query
    ecs.active_entities.intersectInto(&ecs.healths.entity_bitset, &ecs.query_result);
    
    // Direct iteration
    const words = ecs.query_result.words;
    for (words, 0..) |word, word_index| {
        if (word == 0) continue;
        
        var current_word = word;
        const base_index = @as(u32, @intCast(word_index * 64));
        
        while (current_word != 0) {
            const bit_index = @ctz(current_word);
            const entity = base_index + bit_index;
            
            // Direct component access
            const health = &ecs.healths.dense[ecs.healths.entity_to_index[entity]];
            
            health.current -= 1;
            if (health.current < 0) {
                health.current = health.max;
            }
            
            current_word &= current_word - 1;
        }
    }
}

pub fn main() !void {
    // Use page allocator for better performance
    const allocator = std.heap.page_allocator;
    
    std.debug.print("=== Zig Bitset ECS Performance Test (Optimized) ===\n", .{});
    std.debug.print("Testing with optimized bitset operations and direct iteration\n\n", .{});
    
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var ecs = try OptimizedECS.init(allocator);
        defer ecs.deinit();
        
        const setup_start = std.time.nanoTimestamp();
        
        var first_entity: u32 = INVALID_ENTITY;
        
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
            updateTransformSystem(&ecs);
            damageSystem(&ecs);
        }
        
        // Get initial values for verification
        const initial_transform_ptr = ecs.transforms.get(first_entity);
        const initial_health_ptr = ecs.healths.get(first_entity);
        
        const initial_x = if (initial_transform_ptr) |t| t.x else -999.0;
        const initial_health_val = if (initial_health_ptr) |h| h.current else -1;
        
        // Benchmark
        const bench_start = std.time.nanoTimestamp();
        
        for (0..frame_count) |_| {
            ecs.update(0.016);
            updateTransformSystem(&ecs);
            damageSystem(&ecs);
        }
        
        const bench_time_ns = std.time.nanoTimestamp() - bench_start;
        const bench_time_ms = @as(f64, @floatFromInt(bench_time_ns)) / 1_000_000.0;
        const avg_frame_time_ms = bench_time_ms / @as(f64, @floatFromInt(frame_count));
        
        // Get final values for verification
        const final_transform_ptr = ecs.transforms.get(first_entity);
        const final_health_ptr = ecs.healths.get(first_entity);
        
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
    
    std.debug.print("\n=== End of Zig Optimized Performance Test ===\n", .{});
}