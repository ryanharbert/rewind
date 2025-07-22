// Generic ECS - Public API
pub const EntityID = @import("entity.zig").EntityID;
pub const EntityManager = @import("entity.zig").EntityManager;
pub const INVALID_ENTITY = @import("entity.zig").INVALID_ENTITY;

pub const ComponentManager = @import("component.zig").ComponentManager;
pub const Query = @import("query.zig").Query;
pub const World = @import("world.zig").World;
pub const validateComponents = @import("world.zig").validateComponents;

pub const System = @import("system.zig").System;
pub const SystemRegistry = @import("system.zig").SystemRegistry;
pub const Simulation = @import("simulation.zig").Simulation;