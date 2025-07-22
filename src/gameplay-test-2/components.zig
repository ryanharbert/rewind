// Game-specific component types
const std = @import("std");

pub const Transform = struct {
    position: Vec2 = Vec2{ .x = 0.0, .y = 0.0 },
    rotation: f32 = 0.0,
    scale: Vec2 = Vec2{ .x = 1.0, .y = 1.0 },
};

pub const Physics = struct {
    velocity: Vec2 = Vec2{ .x = 0.0, .y = 0.0 },
    acceleration: Vec2 = Vec2{ .x = 0.0, .y = 0.0 },
};

pub const Sprite = struct {
    texture_name: []const u8,
};

pub const Player = struct {
    speed: f32 = 2.0,
};

pub const Enemy = struct {
    speed: f32 = 1.0,
    target_entity: ?u32 = null,
};

// Helper types
pub const Vec2 = struct {
    x: f32,
    y: f32,
};

// Register all game components for the ECS
pub const GameComponents = [_]type{
    Transform,
    Physics,
    Sprite,
    Player,
    Enemy,
};