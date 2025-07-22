const std = @import("std");

// Forward declaration - will be defined per game
pub const InputCommand = @import("input_commands.zig").InputCommand;

// The ECS data (entities, components, etc.) - just alias for now
pub const State = @import("ecs").World;

// All data needed for one simulation frame
pub const Frame = struct {
    state: *State,
    dt: f32,
    time: f64,
    frame_number: u64,
    input: []const InputCommand,
};