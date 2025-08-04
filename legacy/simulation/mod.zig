// Re-export core simulation types
pub const Frame = @import("frame.zig").Frame;
pub const State = @import("frame.zig").State;
pub const InputCommand = @import("input_commands.zig").InputCommand;
pub const System = @import("system.zig").System;
pub const SystemRegistry = @import("system.zig").SystemRegistry;
pub const Simulation = @import("simulation.zig").Simulation;

// Re-export test game systems
pub const test_game_systems = @import("test_game_systems.zig").test_game_systems;