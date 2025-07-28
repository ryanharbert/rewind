const std = @import("std");
const ecs = @import("ecs.zig");

/// Configuration for the rollback system
pub const RollbackConfig = struct {
    /// Maximum frames to keep in history (e.g., 600 = 10 seconds at 60 FPS)
    max_rollback_frames: u32 = 600,
    
    /// Interval for creating full snapshots (e.g., every 60 frames = 1 second)
    snapshot_interval: u32 = 60,
    
    /// Target simulation rate in Hz (ticks per second)
    tick_rate: u32 = 60,
    
    /// Maximum predicted frames allowed
    max_prediction_frames: u32 = 10,
};

/// Generic rollback manager that works with any ECS configuration
pub fn RollbackManager(comptime ECSType: type) type {
    return struct {
        const Self = @This();
        const Frame = ECSType.Frame;
        const FrameState = ECSType.FrameState;
        const InputType = @TypeOf(@as(Frame, undefined).input);
        
        /// System function type - takes frame and executes game logic
        pub const SystemFn = *const fn (frame: *Frame) anyerror!void;
        
        /// Stores a single frame's data with metadata
        const StoredFrame = struct {
            /// The actual frame data
            frame: Frame,
            
            /// Hash of the frame state for desync detection
            checksum: u64,
            
            /// Whether this is a full snapshot or delta
            is_snapshot: bool,
            
            /// Whether this frame has been confirmed by the server
            confirmed: bool,
            
            pub fn deinit(self: *StoredFrame) void {
                ECSType.freeSavedFrame(&self.frame);
            }
        };
        
        /// Input data for a specific frame
        const FrameInput = struct {
            frame_number: u64,
            input: InputType, // Use the input type from ECS config
            player_id: u8 = 0, // For future networking support
        };
        
        /// The current ECS instance
        ecs: *ECSType,
        
        /// Configuration
        config: RollbackConfig,
        
        /// Circular buffer of frame history
        frame_history: std.ArrayList(?StoredFrame),
        
        /// Input buffer for recording and replay
        input_buffer: std.ArrayList(FrameInput),
        
        /// Current simulation frame number
        current_frame: u64,
        
        /// Oldest frame we can rollback to
        oldest_frame: u64,
        
        /// Frame number of the last confirmed state
        last_confirmed_frame: u64,
        
        /// Allocator for dynamic memory
        allocator: std.mem.Allocator,
        
        /// Accumulator for fixed timestep
        time_accumulator: f64,
        
        /// Total elapsed time
        total_time: f64,
        
        /// Systems to run each frame
        systems: std.ArrayList(SystemFn),
        
        pub fn init(allocator: std.mem.Allocator, ecs_instance: *ECSType, config: RollbackConfig) !Self {
            var self = Self{
                .ecs = ecs_instance,
                .config = config,
                .frame_history = try std.ArrayList(?StoredFrame).initCapacity(allocator, config.max_rollback_frames),
                .input_buffer = std.ArrayList(FrameInput).init(allocator),
                .current_frame = 0,
                .oldest_frame = 0,
                .last_confirmed_frame = 0,
                .allocator = allocator,
                .time_accumulator = 0.0,
                .total_time = 0.0,
                .systems = std.ArrayList(SystemFn).init(allocator),
            };
            
            // Initialize frame history with nulls
            try self.frame_history.resize(config.max_rollback_frames);
            for (self.frame_history.items) |*item| {
                item.* = null;
            }
            
            // Save initial frame (frame 0 with empty state)
            try self.saveCurrentFrame(true);
            
            return self;
        }
        
        pub fn deinit(self: *Self) void {
            // Clean up stored frames
            for (self.frame_history.items) |*stored_frame_opt| {
                if (stored_frame_opt.*) |*stored_frame| {
                    stored_frame.deinit();
                }
            }
            
            self.frame_history.deinit();
            self.input_buffer.deinit();
            self.systems.deinit();
        }
        
        /// Calculate checksum of current frame state for desync detection
        fn calculateChecksum(frame: *const Frame) u64 {
            // Simple checksum based on entity count and frame number
            // In production, you'd want a more robust hash of all component data
            var checksum: u64 = frame.frame_number;
            checksum ^= @as(u64, frame.state.entity_count) << 32;
            checksum ^= @as(u64, @intFromFloat(frame.time * 1000000));
            return checksum;
        }
        
        /// Get the index in the circular buffer for a given frame number
        pub fn getBufferIndex(self: *Self, frame_number: u64) usize {
            return @intCast(frame_number % self.config.max_rollback_frames);
        }
        
        /// Save current frame to history
        fn saveCurrentFrame(self: *Self, force_snapshot: bool) !void {
            const current = self.ecs.getFrame();
            const is_snapshot = force_snapshot or (current.frame_number % self.config.snapshot_interval == 0);
            
            // Save the frame
            const saved_frame = try self.ecs.saveFrame(self.allocator);
            
            const stored_frame = StoredFrame{
                .frame = saved_frame,
                .checksum = calculateChecksum(current),
                .is_snapshot = is_snapshot,
                .confirmed = false,
            };
            
            // Store in circular buffer
            const index = self.getBufferIndex(current.frame_number);
            
            // Clean up old frame if exists
            if (self.frame_history.items[index]) |*old_frame| {
                old_frame.deinit();
            }
            
            self.frame_history.items[index] = stored_frame;
            
            // Update oldest frame if we've wrapped around
            if (current.frame_number >= self.config.max_rollback_frames) {
                self.oldest_frame = current.frame_number - self.config.max_rollback_frames + 1;
            }
        }
        
        /// Record input for the current frame
        pub fn recordInput(self: *Self, input: InputType) !void {
            const frame_input = FrameInput{
                .frame_number = self.current_frame,
                .input = input,
                .player_id = 0,
            };
            
            try self.input_buffer.append(frame_input);
            
            // Trim old inputs
            while (self.input_buffer.items.len > 0 and 
                   self.input_buffer.items[0].frame_number < self.oldest_frame) {
                _ = self.input_buffer.orderedRemove(0);
            }
        }
        
        /// Get input for a specific frame
        fn getInputForFrame(self: *Self, frame_number: u64) ?InputType {
            for (self.input_buffer.items) |frame_input| {
                if (frame_input.frame_number == frame_number) {
                    return frame_input.input;
                }
            }
            return null;
        }
        
        /// Rollback to a specific frame
        pub fn rollbackToFrame(self: *Self, target_frame: u64) !void {
            if (target_frame < self.oldest_frame or target_frame > self.current_frame) {
                return error.FrameOutOfRange;
            }
            
            // Find nearest snapshot before target
            var snapshot_frame = target_frame;
            while (snapshot_frame >= self.oldest_frame) {
                const index = self.getBufferIndex(snapshot_frame);
                if (self.frame_history.items[index]) |stored_frame| {
                    if (stored_frame.is_snapshot) {
                        break;
                    }
                }
                
                if (snapshot_frame == 0) break;
                snapshot_frame -= 1;
            }
            
            // Restore from snapshot
            const snapshot_index = self.getBufferIndex(snapshot_frame);
            if (self.frame_history.items[snapshot_index]) |stored_frame| {
                try self.ecs.restoreFrame(&stored_frame.frame);
                self.current_frame = snapshot_frame;
                // Also update time to match
                self.total_time = @as(f64, @floatFromInt(snapshot_frame)) / @as(f64, @floatFromInt(self.config.tick_rate));
            } else {
                return error.SnapshotNotFound;
            }
            
            // Replay frames from snapshot to target
            while (self.current_frame < target_frame) {
                const input = self.getInputForFrame(self.current_frame) orelse std.mem.zeroes(InputType);
                try self.simulateFrame(input);
            }
        }
        
        /// Simulate a single frame with given input
        fn simulateFrame(self: *Self, input: InputType) !void {
            const fixed_dt = 1.0 / @as(f32, @floatFromInt(self.config.tick_rate));
            
            self.current_frame += 1;
            self.total_time = @as(f64, @floatFromInt(self.current_frame)) * fixed_dt;
            
            // Update ECS with input and fixed timestep
            self.ecs.update(input, fixed_dt, self.total_time);
            
            // Run all systems
            const frame = self.ecs.getFrame();
            for (self.systems.items) |system| {
                try system(frame);
            }
            
            // Save frame to history
            try self.saveCurrentFrame(false);
        }
        
        /// Update with variable timestep, runs fixed timestep simulation internally
        pub fn update(self: *Self, dt: f64, input: InputType) !void {
            self.time_accumulator += dt;
            
            const fixed_dt = 1.0 / @as(f64, @floatFromInt(self.config.tick_rate));
            
            // Run simulation at fixed timestep
            while (self.time_accumulator >= fixed_dt) {
                // Record input for this frame
                try self.recordInput(input);
                
                // Simulate with the input
                try self.simulateFrame(input);
                self.time_accumulator -= fixed_dt;
            }
        }
        
        /// Mark frames as confirmed (for networking)
        pub fn confirmFrame(self: *Self, frame_number: u64) void {
            if (frame_number <= self.current_frame and frame_number >= self.oldest_frame) {
                const index = self.getBufferIndex(frame_number);
                if (self.frame_history.items[index]) |*stored_frame| {
                    stored_frame.confirmed = true;
                    self.last_confirmed_frame = frame_number;
                }
            }
        }
        
        /// Get interpolation factor for rendering
        pub fn getInterpolationAlpha(self: *const Self) f32 {
            const fixed_dt = 1.0 / @as(f64, @floatFromInt(self.config.tick_rate));
            return @floatCast(self.time_accumulator / fixed_dt);
        }
        
        /// Get current simulation frame number
        pub fn getCurrentFrame(self: *const Self) u64 {
            return self.current_frame;
        }
        
        /// Check if we can rollback to a specific frame
        pub fn canRollbackToFrame(self: *const Self, frame_number: u64) bool {
            return frame_number >= self.oldest_frame and frame_number <= self.current_frame;
        }
        
        /// Add a system to be executed each frame
        pub fn addSystem(self: *Self, system: SystemFn) !void {
            try self.systems.append(system);
        }
        
        /// Clear all systems
        pub fn clearSystems(self: *Self) void {
            self.systems.clearRetainingCapacity();
        }
    };
}