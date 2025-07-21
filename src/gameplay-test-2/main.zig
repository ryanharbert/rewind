const std = @import("std");
const engine = @import("engine");
const ecs = @import("ecs");

// Game Components
const Player = struct {
    speed: f32 = 200.0,
};

const Enemy = struct {
    speed: f32 = 100.0,
    target_entity: ?ecs.EntityID = null,
};

const Input = struct {
    left: bool = false,
    right: bool = false,
    up: bool = false,
    down: bool = false,
};

// Game Systems
const PlayerSystem = struct {
    pub fn update(world: *ecs.World, input_state: Input, dt: f32) void {
        var query = world.query(.{ Player, ecs.Transform, ecs.Physics });
        while (query.next()) |entity| {
            const player = world.getComponent(entity, Player).?;
            const physics = world.getComponent(entity, ecs.Physics).?;
            
            // Reset velocity
            physics.velocity.x = 0;
            physics.velocity.y = 0;
            
            // Apply input
            if (input_state.left) physics.velocity.x = -player.speed;
            if (input_state.right) physics.velocity.x = player.speed;
            if (input_state.up) physics.velocity.y = -player.speed;
            if (input_state.down) physics.velocity.y = player.speed;
            
            // Normalize diagonal movement
            const speed = std.math.sqrt(physics.velocity.x * physics.velocity.x + 
                                      physics.velocity.y * physics.velocity.y);
            if (speed > player.speed) {
                physics.velocity.x = physics.velocity.x / speed * player.speed;
                physics.velocity.y = physics.velocity.y / speed * player.speed;
            }
        }
    }
};

const EnemySystem = struct {
    pub fn update(world: *ecs.World, dt: f32) void {
        // Find player position
        var player_pos: ?ecs.Transform = null;
        var player_query = world.query(.{ Player, ecs.Transform });
        if (player_query.next()) |player_entity| {
            player_pos = world.getComponent(player_entity, ecs.Transform).*;
        }
        
        if (player_pos == null) return;
        
        // Update enemies to follow player
        var query = world.query(.{ Enemy, ecs.Transform, ecs.Physics });
        while (query.next()) |entity| {
            const enemy = world.getComponent(entity, Enemy).?;
            const transform = world.getComponent(entity, ecs.Transform).?;
            const physics = world.getComponent(entity, ecs.Physics).?;
            
            // Calculate direction to player
            const dx = player_pos.?.position.x - transform.position.x;
            const dy = player_pos.?.position.y - transform.position.y;
            const distance = std.math.sqrt(dx * dx + dy * dy);
            
            if (distance > 0.1) {
                // Move toward player
                physics.velocity.x = (dx / distance) * enemy.speed;
                physics.velocity.y = (dy / distance) * enemy.speed;
            } else {
                // Stop when close
                physics.velocity.x = 0;
                physics.velocity.y = 0;
            }
        }
    }
};

const PhysicsSystem = struct {
    pub fn update(world: *ecs.World, dt: f32) void {
        var query = world.query(.{ ecs.Transform, ecs.Physics });
        while (query.next()) |entity| {
            const transform = world.getComponent(entity, ecs.Transform).?;
            const physics = world.getComponent(entity, ecs.Physics).?;
            
            // Integrate velocity -> position
            transform.position.x += physics.velocity.x * dt;
            transform.position.y += physics.velocity.y * dt;
            
            // Simple screen bounds (temporary)
            if (transform.position.x < 0) transform.position.x = 0;
            if (transform.position.x > 800) transform.position.x = 800;
            if (transform.position.y < 0) transform.position.y = 0;
            if (transform.position.y > 600) transform.position.y = 600;
        }
    }
};

const RenderSystem = struct {
    pub fn update(world: *ecs.World, renderer: *engine.Renderer) void {
        // Query all renderable entities
        var query = world.query(.{ ecs.Transform, ecs.Sprite });
        while (query.next()) |entity| {
            const transform = world.getComponent(entity, ecs.Transform).?;
            const sprite = world.getComponent(entity, ecs.Sprite).?;
            
            // For now, draw a simple colored rectangle based on sprite name
            const color = if (std.mem.eql(u8, sprite.texture_name, "player"))
                engine.Color{ .r = 0.0, .g = 1.0, .b = 0.0, .a = 1.0 } // Green player
            else if (std.mem.eql(u8, sprite.texture_name, "enemy"))
                engine.Color{ .r = 1.0, .g = 0.0, .b = 0.0, .a = 1.0 } // Red enemy
            else
                engine.Color{ .r = 1.0, .g = 1.0, .b = 1.0, .a = 1.0 }; // White default
            
            // Draw as colored rectangle (will be sprites later)
            renderer.drawRect(
                transform.position.x - 16, 
                transform.position.y - 16, 
                32, 32, 
                color
            );
        }
    }
};

// Game State
var world: ecs.World = undefined;
var current_input: Input = Input{};
var game_running = true;

// Timing
const TARGET_FPS: f32 = 60.0;
const FRAME_TIME: f32 = 1.0 / TARGET_FPS;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Initialize engine
    try engine.init();
    defer engine.deinit();
    
    // Initialize ECS world  
    world = ecs.World.init(allocator);
    defer world.deinit();
    
    // Create player entity
    const player = try world.createEntity();
    try world.addComponent(player, Player{});
    try world.addComponent(player, ecs.Transform{ .position = .{ .x = 400.0, .y = 300.0 } });
    try world.addComponent(player, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
    try world.addComponent(player, ecs.Sprite{ .texture_name = "player" });
    
    // Create enemy entities
    for (0..5) |i| {
        const enemy = try world.createEntity();
        try world.addComponent(enemy, Enemy{});
        try world.addComponent(enemy, ecs.Transform{ 
            .position = .{ 
                .x = 100.0 + (@as(f32, @floatFromInt(i)) * 150.0), 
                .y = 100.0 
            } 
        });
        try world.addComponent(enemy, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
        try world.addComponent(enemy, ecs.Sprite{ .texture_name = "enemy" });
    }
    
    std.debug.print("Gameplay Test 2 - ECS Systems Demo\n", .{});
    std.debug.print("Use WASD to move the green player\n", .{});
    std.debug.print("Red enemies will follow you\n", .{});
    std.debug.print("Press ESC to quit\n\n", .{});
    
    var last_time = engine.getTime();
    
    // Main game loop
    while (game_running) {
        const current_time = engine.getTime();
        const dt = @min(current_time - last_time, FRAME_TIME * 5.0); // Cap dt to prevent large jumps
        last_time = current_time;
        
        // Handle input (will be more sophisticated later)
        handleInput();
        
        if (!game_running) break;
        
        // Update simulation (deterministic)
        PlayerSystem.update(&world, current_input, dt);
        EnemySystem.update(&world, dt);
        PhysicsSystem.update(&world, dt);
        
        // Render (non-deterministic)
        engine.beginFrame();
        RenderSystem.update(&world, engine.getRenderer());
        
        // Debug text
        const entity_count = world.entity_count;
        engine.drawText(10, 10, "Entities: {}", .{entity_count});
        engine.drawText(10, 30, "FPS: {d:.1}", .{1.0 / dt});
        
        engine.endFrame();
        
        // Simple frame rate limiting
        std.time.sleep(@intFromFloat(std.math.max(0, (FRAME_TIME - dt) * std.time.ns_per_s)));
    }
}

fn handleInput() void {
    // Poll engine input (this will be more sophisticated)
    current_input.left = engine.isKeyPressed(engine.Key.A) or engine.isKeyPressed(engine.Key.Left);
    current_input.right = engine.isKeyPressed(engine.Key.D) or engine.isKeyPressed(engine.Key.Right);
    current_input.up = engine.isKeyPressed(engine.Key.W) or engine.isKeyPressed(engine.Key.Up);
    current_input.down = engine.isKeyPressed(engine.Key.S) or engine.isKeyPressed(engine.Key.Down);
    
    if (engine.isKeyPressed(engine.Key.Escape)) {
        game_running = false;
    }
}