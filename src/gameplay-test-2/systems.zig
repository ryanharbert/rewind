const std = @import("std");
const components = @import("components.zig");
const InputCommand = @import("input.zig").InputCommand;
const ecs = @import("ecs");

// Game-specific types
const Transform = components.Transform;
const Physics = components.Physics;
const Sprite = components.Sprite;
const Player = components.Player;
const Enemy = components.Enemy;
const Vec2 = components.Vec2;

// World boundaries
const WORLD_BOUNDS = struct {
    min_x: f32 = -4.0,
    max_x: f32 = 4.0, 
    min_y: f32 = -4.0,
    max_y: f32 = 4.0,
}{};

// Frame context for systems (generic)
pub fn Frame(comptime WorldType: type) type {
    return struct {
        world: *WorldType,
        dt: f32,
        time: f64,
        frame_number: u64,
        input: []const InputCommand,
    };
}

// Game Systems
pub const BackgroundSystem = struct {
    pub fn init(frame: anytype) !void {
        std.debug.print("Initializing BackgroundSystem - creating background entity\n", .{});
        
        const background = try frame.world.createEntity();
        try frame.world.addComponent(background, Transform{ 
            .position = Vec2{ .x = 0.0, .y = 0.0 }, 
            .scale = Vec2{ .x = 8.0, .y = 8.0 } 
        });
        try frame.world.addComponent(background, Sprite{ .texture_name = "background" });
    }
    
    pub fn update(frame: anytype) void {
        _ = frame; // Background doesn't need updating
    }
};

pub const PlayerSystem = struct {
    pub fn init(frame: anytype) !void {
        std.debug.print("Initializing PlayerSystem - creating player entity\n", .{});
        
        const player = try frame.world.createEntity();
        try frame.world.addComponent(player, Player{});
        try frame.world.addComponent(player, Transform{ 
            .position = Vec2{ .x = 0.0, .y = 0.0 }, 
            .scale = Vec2{ .x = 0.5, .y = 0.5 } 
        });
        try frame.world.addComponent(player, Physics{ .velocity = Vec2{ .x = 0.0, .y = 0.0 } });
        try frame.world.addComponent(player, Sprite{ .texture_name = "player" });
    }
    
    pub fn update(frame: anytype) void {
        var query = frame.world.query(&[_]type{ Player, Transform, Physics }) catch return;
        defer query.deinit();
        
        while (query.next()) |entity| {
            const player = frame.world.getComponent(entity, Player).?;
            const transform = frame.world.getComponent(entity, Transform).?;
            const physics = frame.world.getComponent(entity, Physics).?;
            
            // Tank-style controls
            const rotation_speed = 3.0;
            
            // Reset velocity
            physics.velocity.x = 0;
            physics.velocity.y = 0;
            
            // Process input commands
            for (frame.input) |command| {
                switch (command) {
                    .rotate_left => |rotate| {
                        transform.rotation -= rotation_speed * rotate.strength * frame.dt;
                    },
                    .rotate_right => |rotate| {
                        transform.rotation += rotation_speed * rotate.strength * frame.dt;
                    },
                    .move_forward => |move| {
                        const forward_x = @sin(transform.rotation);
                        const forward_y = @cos(transform.rotation);
                        physics.velocity.x = forward_x * move.strength * player.speed;
                        physics.velocity.y = forward_y * move.strength * player.speed;
                    },
                    .move_backward => |move| {
                        const forward_x = @sin(transform.rotation);
                        const forward_y = @cos(transform.rotation);
                        physics.velocity.x = -forward_x * move.strength * player.speed;
                        physics.velocity.y = -forward_y * move.strength * player.speed;
                    },
                }
            }
        }
    }
};

pub const EnemySystem = struct {
    pub fn init(frame: anytype) !void {
        std.debug.print("Initializing EnemySystem - creating enemy entities\n", .{});
        
        // Create enemy entities
        for (0..5) |i| {
            const enemy = try frame.world.createEntity();
            try frame.world.addComponent(enemy, Enemy{});
            try frame.world.addComponent(enemy, Transform{ 
                .position = Vec2{ 
                    .x = -2.0 + (@as(f32, @floatFromInt(i)) * 1.0), 
                    .y = 1.0 
                },
                .scale = Vec2{ .x = 0.4, .y = 0.4 }
            });
            try frame.world.addComponent(enemy, Physics{ .velocity = Vec2{ .x = 0.0, .y = 0.0 } });
            try frame.world.addComponent(enemy, Sprite{ .texture_name = "enemy" });
        }
    }
    
    pub fn update(frame: anytype) void {
        // Find player position
        var player_pos: ?Transform = null;
        {
            var player_query = frame.world.query(&[_]type{ Player, Transform }) catch return;
            defer player_query.deinit();
            
            if (player_query.next()) |player_entity| {
                if (frame.world.getComponent(player_entity, Transform)) |transform| {
                    player_pos = transform.*;
                }
            }
        }
        
        if (player_pos == null) return;
        
        // Update enemies to follow player
        var query = frame.world.query(&[_]type{ Enemy, Transform, Physics }) catch return;
        defer query.deinit();
        
        while (query.next()) |entity| {
            const enemy = frame.world.getComponent(entity, Enemy).?;
            const transform = frame.world.getComponent(entity, Transform).?;
            const physics = frame.world.getComponent(entity, Physics).?;
            
            // Calculate direction to player
            const dx = player_pos.?.position.x - transform.position.x;
            const dy = player_pos.?.position.y - transform.position.y;
            const distance = std.math.sqrt(dx * dx + dy * dy);
            
            const stop_distance = 0.3;
            
            if (distance > stop_distance) {
                // Move toward player
                physics.velocity.x = (dx / distance) * enemy.speed;
                physics.velocity.y = (dy / distance) * enemy.speed;
                
                // Face the player
                transform.rotation = std.math.atan2(dx, dy);
            } else {
                // Stop when close
                physics.velocity.x = 0;
                physics.velocity.y = 0;
            }
        }
    }
};

pub const PhysicsSystem = struct {
    pub fn init(frame: anytype) !void {
        _ = frame;
        std.debug.print("Initializing PhysicsSystem\n", .{});
    }
    
    pub fn update(frame: anytype) void {
        var query = frame.world.query(&[_]type{ Transform, Physics }) catch return;
        defer query.deinit();
        
        while (query.next()) |entity| {
            const transform = frame.world.getComponent(entity, Transform).?;
            const physics = frame.world.getComponent(entity, Physics).?;
            
            // Integrate velocity -> position
            transform.position.x += physics.velocity.x * frame.dt;
            transform.position.y += physics.velocity.y * frame.dt;
            
            // World boundary constraints
            if (transform.position.x < WORLD_BOUNDS.min_x) transform.position.x = WORLD_BOUNDS.min_x;
            if (transform.position.x > WORLD_BOUNDS.max_x) transform.position.x = WORLD_BOUNDS.max_x;
            if (transform.position.y < WORLD_BOUNDS.min_y) transform.position.y = WORLD_BOUNDS.min_y;
            if (transform.position.y > WORLD_BOUNDS.max_y) transform.position.y = WORLD_BOUNDS.max_y;
        }
    }
};

// System array - order matters!
pub const game_systems = [_]ecs.System{
    ecs.System{ .name = "background", .initFn = BackgroundSystem.init, .updateFn = BackgroundSystem.update },
    ecs.System{ .name = "player", .initFn = PlayerSystem.init, .updateFn = PlayerSystem.update },
    ecs.System{ .name = "enemy", .initFn = EnemySystem.init, .updateFn = EnemySystem.update },
    ecs.System{ .name = "physics", .initFn = PhysicsSystem.init, .updateFn = PhysicsSystem.update },
};