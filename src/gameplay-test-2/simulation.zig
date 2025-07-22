// Game-specific simulation setup
const ecs = @import("ecs");
const components = @import("components.zig");
const systems = @import("systems.zig");
const InputCommand = @import("input.zig").InputCommand;

// Create the game simulation type with our specific components and systems
pub const GameSimulation = ecs.Simulation(
    &components.GameComponents,
    InputCommand,
    .{
        systems.BackgroundSystem,
        systems.PlayerSystem,
        systems.EnemySystem,
        systems.PhysicsSystem,
    }
);