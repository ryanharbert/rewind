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

// Simple bitset implementation (like Go/C# versions)
const BitSet = struct {
    size: u32,
    words: []u64,
    allocator: std.mem.Allocator,
    
    const Self = @This();
    
    pub fn init(allocator: std.mem.Allocator, size: u32) !Self {
        const word_count = (size + 63) / 64;
        const words = try allocator.alloc(u64, word_count);
        @memset(words, 0);
        return Self{
            .size = size,
            .words = words,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.words);
    }
    
    pub fn set(self: *Self, index: u32) void {
        if (index >= self.size) return;
        const word_index = index / 64;
        const bit_index = @as(u6, @intCast(index % 64));
        self.words[word_index] |= @as(u64, 1) << bit_index;
    }
    
    pub fn unset(self: *Self, index: u32) void {
        if (index >= self.size) return;
        const word_index = index / 64;
        const bit_index = @as(u6, @intCast(index % 64));
        self.words[word_index] &= ~(@as(u64, 1) << bit_index);
    }
    
    pub fn isSet(self: *const Self, index: u32) bool {
        if (index >= self.size) return false;
        const word_index = index / 64;
        const bit_index = @as(u6, @intCast(index % 64));
        return (self.words[word_index] & (@as(u64, 1) << bit_index)) != 0;
    }
    
    pub fn intersectWith(self: *const Self, other: *const Self) !BitSet {
        var result = try BitSet.init(self.allocator, self.size);
        const min_len = @min(self.words.len, other.words.len);
        
        for (0..min_len) |i| {
            result.words[i] = self.words[i] & other.words[i];
        }
        
        return result;
    }
    
    // Direct iteration like C# foreach and Go ForEach
    pub fn forEach(self: *const Self, callback: fn(u32) void) void {
        for (self.words, 0..) |word, word_index| {
            if (word == 0) continue;
            
            var current_word = word;
            const base_index = @as(u32, @intCast(word_index * 64));
            
            while (current_word != 0) {
                const bit_index = @ctz(current_word);
                const entity = base_index + bit_index;
                callback(entity);
                current_word &= current_word - 1; // Clear lowest bit
            }
        }
    }
};

// Direct access component storage (like C# and Go versions)
fn ComponentStorage(comptime T: type) type {
    return struct {
        const Self = @This();
        
        // Dense array like C# version
        dense_array: std.ArrayList(T),
        entity_bitset: BitSet,
        entity_to_index: [MAX_ENTITIES]u32,
        index_to_entity: std.ArrayList(u32),
        count: u32,
        
        pub fn init(allocator: std.mem.Allocator) !Self {
            return Self{
                .dense_array = std.ArrayList(T).init(allocator),
                .entity_bitset = try BitSet.init(allocator, MAX_ENTITIES),
                .entity_to_index = [_]u32{0} ** MAX_ENTITIES,
                .index_to_entity = std.ArrayList(u32).init(allocator),
                .count = 0,
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.dense_array.deinit();
            self.entity_bitset.deinit();
            self.index_to_entity.deinit();
        }
        
        pub fn add(self: *Self, entity: u32, component: T) !void {
            if (self.entity_bitset.isSet(entity)) return;
            
            const index = self.count;
            try self.dense_array.append(component);
            try self.index_to_entity.append(entity);
            self.entity_to_index[entity] = index;
            self.entity_bitset.set(entity);
            self.count += 1;
        }
        
        // Direct access to dense array element (like C# ref access)
        pub fn getDirect(self: *Self, entity: u32) ?*T {
            if (!self.entity_bitset.isSet(entity)) return null;
            const index = self.entity_to_index[entity];
            return &self.dense_array.items[index];
        }
    };
}

// Direct access ECS (like C# and Go versions)
const DirectECS = struct {
    transforms: ComponentStorage(Transform),
    velocities: ComponentStorage(Velocity),
    healths: ComponentStorage(Health),
    active_entities: BitSet,
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
            .next_entity = 0,
            .entity_count = 0,
            .delta_time = 0.0,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Self) void {
        self.transforms.deinit();
        self.velocities.deinit();
        self.healths.deinit();
        self.active_entities.deinit();
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
    
    pub fn addTransform(self: *Self, entity: u32, component: Transform) !void {
        try self.transforms.add(entity, component);
    }
    
    pub fn addVelocity(self: *Self, entity: u32, component: Velocity) !void {
        try self.velocities.add(entity, component);
    }
    
    pub fn addHealth(self: *Self, entity: u32, component: Health) !void {
        try self.healths.add(entity, component);
    }
    
    // Query with direct bitset access (like C# and Go)
    pub fn queryTransformVelocity(self: *Self) !BitSet {
        var result = try self.active_entities.intersectWith(&self.transforms.entity_bitset);
        const final_result = try result.intersectWith(&self.velocities.entity_bitset);
        result.deinit();
        return final_result;
    }
    
    pub fn queryHealth(self: *Self) !BitSet {
        return try self.active_entities.intersectWith(&self.healths.entity_bitset);
    }
    
    pub fn update(self: *Self, delta_time: f32) void {
        self.delta_time = delta_time;
    }
};

// Global variables for systems (to avoid closure issues)
var g_ecs: *DirectECS = undefined;

fn transformSystemCallback(entity: u32) void {
    const transform_ptr = g_ecs.transforms.getDirect(entity);
    const velocity_ptr = g_ecs.velocities.getDirect(entity);
    
    if (transform_ptr != null and velocity_ptr != null) {
        const transform = transform_ptr.?;
        const velocity = velocity_ptr.?;
        
        // Direct modification (like C# ref access)
        transform.x += velocity.dx * g_ecs.delta_time;
        transform.y += velocity.dy * g_ecs.delta_time;
        transform.rotation += velocity.angular * g_ecs.delta_time;
        
        // Keep rotation in bounds
        if (transform.rotation > 360.0) transform.rotation -= 360.0;
        if (transform.rotation < 0.0) transform.rotation += 360.0;
    }
}

fn healthSystemCallback(entity: u32) void {
    const health_ptr = g_ecs.healths.getDirect(entity);
    
    if (health_ptr != null) {
        const health = health_ptr.?;
        health.current -= 1;
        if (health.current < 0) health.current = health.max;
    }
}

// Direct access systems (like C# and Go versions)
fn directUpdateTransformSystem(ecs: *DirectECS) !void {
    g_ecs = ecs;
    var query_bitset = try ecs.queryTransformVelocity();
    defer query_bitset.deinit();
    
    // Direct iteration like C# foreach
    query_bitset.forEach(transformSystemCallback);
}

fn directDamageSystem(ecs: *DirectECS) !void {
    g_ecs = ecs;
    var query_bitset = try ecs.queryHealth();
    defer query_bitset.deinit();
    
    query_bitset.forEach(healthSystemCallback);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    std.debug.print("=== Zig Bitset ECS Performance Test (Fixed Direct Access - C# Style) ===\n", .{});
    std.debug.print("Testing with direct component access and bitset iteration\n\n", .{});
    
    // Test different entity counts
    const entity_counts = [_]u32{ 100, 250, 500, 750, 1000 };
    const frame_count = 10000;
    
    for (entity_counts) |entity_count| {
        std.debug.print("\n--- Testing {} entities for {} frames ---\n", .{ entity_count, frame_count });
        
        var ecs = try DirectECS.init(allocator);
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
            try directUpdateTransformSystem(&ecs);
            try directDamageSystem(&ecs);
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
            try directUpdateTransformSystem(&ecs);
            try directDamageSystem(&ecs);
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
    
    std.debug.print("\n=== End of Zig Fixed Direct Access Performance Test ===\n", .{});
}