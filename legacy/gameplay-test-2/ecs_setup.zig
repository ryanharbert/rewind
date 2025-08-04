// Complete ECS setup for gameplay-test-2 - everything in one place!
const std = @import("std");
const ecs = @import("ecs");
const components = @import("components.zig");
const systems = @import("systems.zig");
const InputCommand = @import("input.zig").InputCommand;

// Compile the complete ECS simulation for this game
pub const GameSimulation = ecs.Simulation.compile(.{
    .components = &components.GameComponents,
    .input = InputCommand,
    .systems = .{
        systems.BackgroundSystem,
        systems.PlayerSystem,
        systems.EnemySystem,
        systems.PhysicsSystem,
    },
});

// Export the concrete Frame type for systems to use
pub const Frame = GameSimulation.Frame;

// Initialize and setup the ECS simulation
pub fn initECS(allocator: std.mem.Allocator, initial_time: f64) !GameSimulation {
    var simulation = GameSimulation.init(allocator);
    
    // Initialize all systems (creates entities)
    try simulation.initSystems(initial_time);
    
    return simulation;
}