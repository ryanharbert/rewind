const std = @import("std");
const Frame = @import("frame.zig").Frame;
const InputCommand = @import("input_commands.zig").InputCommand;
const System = @import("system.zig").System;
const ecs = @import("ecs");

// World boundaries
const WORLD_BOUNDS = struct {
    min_x: f32 = -4.0,
    max_x: f32 = 4.0, 
    min_y: f32 = -4.0,
    max_y: f32 = 4.0,
}{};

// Test Game Systems
const PlayerSystem = struct {
    pub fn init(frame: *Frame) !void {
        std.debug.print("Initializing PlayerSystem - creating player entity\n", .{});
        
        // Create player entity
        const player = try frame.state.createEntity();
        try frame.state.addComponent(player, ecs.Player{});
        try frame.state.addComponent(player, ecs.Transform{ 
            .position = .{ .x = 0.0, .y = 0.0 }, 
            .scale = .{ .x = 0.5, .y = 0.5 } 
        });
        try frame.state.addComponent(player, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
        try frame.state.addComponent(player, ecs.Sprite{ .texture_name = "player" });
    }
    
    pub fn update(frame: *Frame) void {
        var query = frame.state.query(.{ ecs.Player, ecs.Transform, ecs.Physics });
        defer query.deinit();
        
        while (query.next()) |entity| {
            const player = frame.state.getComponent(entity, ecs.Player).?;
            const transform = frame.state.getComponent(entity, ecs.Transform).?;
            const physics = frame.state.getComponent(entity, ecs.Physics).?;
            
            // Tank-style controls: left/right to rotate, up/down to move forward/backward
            const rotation_speed = 3.0; // radians per second
            
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

const EnemySystem = struct {
    pub fn init(frame: *Frame) !void {
        std.debug.print("Initializing EnemySystem - creating enemy entities\n", .{});
        
        // Create enemy entities (spread around the world)
        for (0..5) |i| {
            const enemy = try frame.state.createEntity();
            try frame.state.addComponent(enemy, ecs.Enemy{});
            try frame.state.addComponent(enemy, ecs.Transform{ 
                .position = .{ 
                    .x = -2.0 + (@as(f32, @floatFromInt(i)) * 1.0), 
                    .y = 1.0 
                },
                .scale = .{ .x = 0.4, .y = 0.4 }
            });
            try frame.state.addComponent(enemy, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
            try frame.state.addComponent(enemy, ecs.Sprite{ .texture_name = "enemy" });
        }
    }
    
    pub fn update(frame: *Frame) void {
        // Find player position
        var player_pos: ?ecs.Transform = null;
        {
            var player_query = frame.state.query(.{ ecs.Player, ecs.Transform });
            defer player_query.deinit();
            
            if (player_query.next()) |player_entity| {
                if (frame.state.getComponent(player_entity, ecs.Transform)) |transform| {
                    player_pos = transform.*;
                }
            }
        }
        
        if (player_pos == null) return;
        
        // Update enemies to follow player
        var query = frame.state.query(.{ ecs.Enemy, ecs.Transform, ecs.Physics });
        defer query.deinit();
        
        while (query.next()) |entity| {
            const enemy = frame.state.getComponent(entity, ecs.Enemy).?;
            const transform = frame.state.getComponent(entity, ecs.Transform).?;
            const physics = frame.state.getComponent(entity, ecs.Physics).?;
            
            // Calculate direction to player
            const dx = player_pos.?.position.x - transform.position.x;
            const dy = player_pos.?.position.y - transform.position.y;
            const distance = std.math.sqrt(dx * dx + dy * dy);
            
            const stop_distance = 0.3; // Stop when close
            
            if (distance > stop_distance) {
                // Move toward player
                physics.velocity.x = (dx / distance) * enemy.speed;
                physics.velocity.y = (dy / distance) * enemy.speed;
                
                // Face the player (rotate towards movement direction)
                transform.rotation = std.math.atan2(dx, dy);
            } else {
                // Stop when close
                physics.velocity.x = 0;
                physics.velocity.y = 0;
            }
        }
    }
};

const PhysicsSystem = struct {
    pub fn init(frame: *Frame) !void {
        _ = frame; // Physics system doesn't need to create entities
        std.debug.print("Initializing PhysicsSystem\n", .{});
    }
    
    pub fn update(frame: *Frame) void {
        var query = frame.state.query(.{ ecs.Transform, ecs.Physics });
        defer query.deinit();
        
        while (query.next()) |entity| {
            const transform = frame.state.getComponent(entity, ecs.Transform).?;
            const physics = frame.state.getComponent(entity, ecs.Physics).?;
            
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

const BackgroundSystem = struct {
    pub fn init(frame: *Frame) !void {
        std.debug.print("Initializing BackgroundSystem - creating background entity\n", .{});
        
        // Create background entity (large, centered)
        const background = try frame.state.createEntity();
        try frame.state.addComponent(background, ecs.Transform{ 
            .position = .{ .x = 0.0, .y = 0.0 }, 
            .scale = .{ .x = 8.0, .y = 8.0 } 
        });
        try frame.state.addComponent(background, ecs.Sprite{ .texture_name = "background" });
    }
    
    pub fn update(frame: *Frame) void {
        // Background doesn't need updating
        _ = frame;
    }
};

// System array - order matters!
pub const test_game_systems = [_]System{
    System{ .name = "background", .initFn = BackgroundSystem.init, .updateFn = BackgroundSystem.update },
    System{ .name = "player", .initFn = PlayerSystem.init, .updateFn = PlayerSystem.update },
    System{ .name = "enemy", .initFn = EnemySystem.init, .updateFn = EnemySystem.update },
    System{ .name = "physics", .initFn = PhysicsSystem.init, .updateFn = PhysicsSystem.update },
};