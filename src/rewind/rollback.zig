const std = @import("std");

/// High-performance rollback system optimized for netcode
/// Uses single contiguous buffer with frame slots for maximum copy speed
pub fn NetcodeRollback(comptime EcsType: type, comptime window_size: u32, comptime max_frame_size: u32) type {
    return struct {
        const Self = @This();
        const WINDOW_SIZE = window_size;
        const MAX_FRAME_SIZE = max_frame_size;
        const TOTAL_BUFFER_SIZE = WINDOW_SIZE * MAX_FRAME_SIZE;
        
        // Single contiguous buffer for all frames
        buffer: [TOTAL_BUFFER_SIZE]u8,
        frame_sizes: [WINDOW_SIZE]u32,
        current_frame_index: u32,
        frames_stored: u32,
        
        // Arena allocators for each frame slot (reused)
        arena_states: [WINDOW_SIZE]std.heap.FixedBufferAllocator,
        
        pub fn init() Self {
            var self = Self{
                .buffer = undefined,
                .frame_sizes = [_]u32{0} ** WINDOW_SIZE,
                .current_frame_index = 0,
                .frames_stored = 0,
                .arena_states = undefined,
            };
            
            // Initialize arena allocators for each frame slot
            for (0..WINDOW_SIZE) |i| {
                const frame_start = i * MAX_FRAME_SIZE;
                const frame_buffer = self.buffer[frame_start..frame_start + MAX_FRAME_SIZE];
                self.arena_states[i] = std.heap.FixedBufferAllocator.init(frame_buffer);
            }
            
            return self;
        }
        
        /// Save current ECS state to next frame slot
        pub fn saveFrame(self: *Self, ecs: *const EcsType) !void {
            const frame_index = self.current_frame_index % WINDOW_SIZE;
            
            // Reset arena for this frame slot
            const frame_start = frame_index * MAX_FRAME_SIZE;
            const frame_buffer = self.buffer[frame_start..frame_start + MAX_FRAME_SIZE];
            self.arena_states[frame_index] = std.heap.FixedBufferAllocator.init(frame_buffer);
            
            const arena_allocator = self.arena_states[frame_index].allocator();
            
            // Save ECS frame data using arena allocator (all data becomes contiguous)
            const saved_frame = try ecs.saveFrame(arena_allocator);
            
            // Track actual frame size used
            self.frame_sizes[frame_index] = @intCast(self.arena_states[frame_index].end_index);
            
            // Free the temporary frame (we have the data in our buffer now)
            EcsType.freeSavedFrame(@constCast(&saved_frame));
            
            self.current_frame_index += 1;
            if (self.frames_stored < WINDOW_SIZE) {
                self.frames_stored += 1;
            }
        }
        
        /// Restore ECS to a previous frame (0 = most recent, 1 = one frame back, etc)
        pub fn restoreToFrame(self: *const Self, ecs: *EcsType, frames_back: u32) !void {
            _ = ecs;
            if (frames_back >= self.frames_stored) {
                return error.FrameNotAvailable;
            }
            
            const target_index = (self.current_frame_index - 1 - frames_back) % WINDOW_SIZE;
            const frame_start = target_index * MAX_FRAME_SIZE;
            const frame_size = self.frame_sizes[target_index];
            
            // Create temporary frame from our buffer data
            var temp_arena = std.heap.FixedBufferAllocator.init(@constCast(self.buffer[frame_start..frame_start + frame_size]));
            const temp_allocator = temp_arena.allocator();
            
            // Reconstruct frame from buffer (this is the tricky part)
            // For now, we'll need to recreate the frame structure
            // This is where we'd need ECS support for loading from buffer
            _ = temp_allocator;
            return error.NotImplementedYet;
        }
        
        /// Copy frame data from one slot to another (ultra fast single memcpy)
        pub fn copyFrame(self: *Self, from_frames_back: u32, to_frames_back: u32) !void {
            if (from_frames_back >= self.frames_stored or to_frames_back >= self.frames_stored) {
                return error.FrameNotAvailable;
            }
            
            const from_index = (self.current_frame_index - 1 - from_frames_back) % WINDOW_SIZE;
            const to_index = (self.current_frame_index - 1 - to_frames_back) % WINDOW_SIZE;
            
            const from_start = from_index * MAX_FRAME_SIZE;
            const to_start = to_index * MAX_FRAME_SIZE;
            const frame_size = self.frame_sizes[from_index];
            
            // FASTEST POSSIBLE: Single memcpy within same buffer
            @memcpy(
                self.buffer[to_start..to_start + frame_size],
                self.buffer[from_start..from_start + frame_size]
            );
            
            self.frame_sizes[to_index] = frame_size;
        }
        
        /// Get memory usage statistics
        pub fn getStats(self: *const Self) struct { 
            total_memory: u32, 
            used_memory: u32, 
            frames_stored: u32,
            avg_frame_size: u32,
        } {
            var used_memory: u32 = 0;
            for (0..self.frames_stored) |i| {
                used_memory += self.frame_sizes[i];
            }
            
            const avg_frame_size = if (self.frames_stored > 0) used_memory / self.frames_stored else 0;
            
            return .{
                .total_memory = TOTAL_BUFFER_SIZE,
                .used_memory = used_memory,
                .frames_stored = self.frames_stored,
                .avg_frame_size = avg_frame_size,
            };
        }
        
        /// Reset rollback buffer
        pub fn reset(self: *Self) void {
            self.current_frame_index = 0;
            self.frames_stored = 0;
            @memset(&self.frame_sizes, 0);
            
            // Reset all arena states
            for (0..WINDOW_SIZE) |i| {
                const frame_start = i * MAX_FRAME_SIZE;
                const frame_buffer = self.buffer[frame_start..frame_start + MAX_FRAME_SIZE];
                self.arena_states[i] = std.heap.FixedBufferAllocator.init(frame_buffer);
            }
        }
    };
}