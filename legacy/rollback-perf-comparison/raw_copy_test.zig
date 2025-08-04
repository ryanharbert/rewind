const std = @import("std");

// Raw frame data - exactly what needs to be copied for rollback
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

// Fixed-size frame data structure - no allocations
const RawFrameData = struct {
    const MAX_ENTITIES = 1024;
    
    // Entity data
    active_entities: [MAX_ENTITIES / 64]u64, // Bitset as u64 array
    entity_count: u32,
    
    // Component data - fixed size arrays, only copying used portion
    transforms: [MAX_ENTITIES]Transform,
    velocities: [MAX_ENTITIES]Velocity,
    healths: [MAX_ENTITIES]Health,
    
    // Component masks
    has_transform: [MAX_ENTITIES / 64]u64,
    has_velocity: [MAX_ENTITIES / 64]u64,
    has_health: [MAX_ENTITIES / 64]u64,
    
    // Entity mappings for sparse set
    transform_count: u32,
    velocity_count: u32,
    health_count: u32,
    
    pub fn calculateCopySize(entity_count: u32, transform_count: u32, velocity_count: u32, health_count: u32) usize {
        _ = entity_count;
        return @sizeOf([MAX_ENTITIES / 64]u64) + // active_entities
               @sizeOf(u32) + // entity_count
               transform_count * @sizeOf(Transform) +
               velocity_count * @sizeOf(Velocity) +
               health_count * @sizeOf(Health) +
               @sizeOf([MAX_ENTITIES / 64]u64) + // has_transform
               @sizeOf([MAX_ENTITIES / 64]u64) + // has_velocity 
               @sizeOf([MAX_ENTITIES / 64]u64) + // has_health
               @sizeOf(u32) + // transform_count
               @sizeOf(u32) + // velocity_count
               @sizeOf(u32);  // health_count
    }
    
    pub fn copyFrom(self: *RawFrameData, other: *const RawFrameData) void {
        // Raw memory copy - this is what we're actually measuring
        @memcpy(&self.active_entities, &other.active_entities);
        self.entity_count = other.entity_count;
        
        // Only copy used portions of component arrays
        if (other.transform_count > 0) {
            @memcpy(self.transforms[0..other.transform_count], other.transforms[0..other.transform_count]);
        }
        if (other.velocity_count > 0) {
            @memcpy(self.velocities[0..other.velocity_count], other.velocities[0..other.velocity_count]);
        }
        if (other.health_count > 0) {
            @memcpy(self.healths[0..other.health_count], other.healths[0..other.health_count]);
        }
        
        @memcpy(&self.has_transform, &other.has_transform);
        @memcpy(&self.has_velocity, &other.has_velocity);
        @memcpy(&self.has_health, &other.has_health);
        
        self.transform_count = other.transform_count;
        self.velocity_count = other.velocity_count;
        self.health_count = other.health_count;
    }
};

pub fn main() !void {
    std.debug.print("=== Raw Memory Copy Performance Test ===\\n", .{});
    
    const entity_counts = [_]u32{ 100, 500, 1000 };
    const frame_count = 10000; // More iterations for better precision
    
    for (entity_counts) |entity_count| {
        std.debug.print("\\n--- {} Entities ---\\n", .{entity_count});
        
        // Create source frame data
        var source_frame = std.mem.zeroes(RawFrameData);
        source_frame.entity_count = entity_count;
        
        // Fill with realistic data
        const transform_count = entity_count;
        const velocity_count = (entity_count * 4) / 5; // 80%
        const health_count = (entity_count * 3) / 5;   // 60%
        
        source_frame.transform_count = transform_count;
        source_frame.velocity_count = velocity_count;
        source_frame.health_count = health_count;
        
        for (0..transform_count) |i| {
            source_frame.transforms[i] = Transform{
                .x = @floatFromInt(i % 100),
                .y = @floatFromInt(i / 100),
                .rotation = 0.0,
            };
        }
        
        for (0..velocity_count) |i| {
            source_frame.velocities[i] = Velocity{
                .dx = @as(f32, @floatFromInt(@as(i32, @intCast(i % 10)) - 5)) * 2.0,
                .dy = @as(f32, @floatFromInt(@as(i32, @intCast(i % 7)) - 3)) * 2.0,
                .angular = @as(f32, @floatFromInt(i % 180)),
            };
        }
        
        for (0..health_count) |i| {
            source_frame.healths[i] = Health{
                .current = 100,
                .max = 100,
            };
        }
        
        // Set up bitsets (simplified)
        for (0..entity_count) |i| {
            const word_index = i / 64;
            const bit_index = @as(u6, @intCast(i % 64));
            source_frame.active_entities[word_index] |= @as(u64, 1) << bit_index;
            source_frame.has_transform[word_index] |= @as(u64, 1) << bit_index;
            
            if (i < velocity_count) {
                source_frame.has_velocity[word_index] |= @as(u64, 1) << bit_index;
            }
            if (i < health_count) {
                source_frame.has_health[word_index] |= @as(u64, 1) << bit_index;
            }
        }
        
        // Pre-allocate destination frames to avoid allocation overhead
        var dest_frames = std.ArrayList(RawFrameData).init(std.heap.page_allocator);
        defer dest_frames.deinit();
        
        try dest_frames.resize(frame_count);
        
        // Test raw memory copying
        const copy_start = std.time.nanoTimestamp();
        for (0..frame_count) |i| {
            dest_frames.items[i].copyFrom(&source_frame);
        }
        const copy_time_ns = std.time.nanoTimestamp() - copy_start;
        
        // Test restoration (copy back)
        const restore_start = std.time.nanoTimestamp();
        for (0..frame_count) |i| {
            const frame_index = i % dest_frames.items.len;
            source_frame.copyFrom(&dest_frames.items[frame_index]);
        }
        const restore_time_ns = std.time.nanoTimestamp() - restore_start;
        
        // Calculate metrics
        const copy_time_ms = @as(f64, @floatFromInt(copy_time_ns)) / 1_000_000.0;
        const restore_time_ms = @as(f64, @floatFromInt(restore_time_ns)) / 1_000_000.0;
        const avg_copy_time_us = (copy_time_ms * 1000.0) / @as(f64, @floatFromInt(frame_count));
        const avg_restore_time_us = (restore_time_ms * 1000.0) / @as(f64, @floatFromInt(frame_count));
        
        const copy_size = RawFrameData.calculateCopySize(entity_count, transform_count, velocity_count, health_count);
        const copy_size_kb = @as(f64, @floatFromInt(copy_size)) / 1024.0;
        
        std.debug.print("Raw copy time: {d:.2}μs avg ({d:.2}ms total)\\n", .{ avg_copy_time_us, copy_time_ms });
        std.debug.print("Raw restore time: {d:.2}μs avg ({d:.2}ms total)\\n", .{ avg_restore_time_us, restore_time_ms });
        std.debug.print("Frame size: {d:.1}KB ({} bytes)\\n", .{ copy_size_kb, copy_size });
        std.debug.print("Copy bandwidth: {d:.1}MB/s\\n", .{ (copy_size_kb / 1024.0) / (avg_copy_time_us / 1_000_000.0) });
        std.debug.print("Components: {} Transform, {} Velocity, {} Health\\n", .{ transform_count, velocity_count, health_count });
    }
    
    std.debug.print("\\n=== End Raw Copy Test ===\\n", .{});
}