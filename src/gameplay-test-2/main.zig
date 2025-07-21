const std = @import("std");
const engine = @import("engine");
const ecs = @import("ecs");

// Import game components from ECS
const Player = ecs.Player;
const Enemy = ecs.Enemy;

const Input = struct {
    left: bool = false,
    right: bool = false,
    up: bool = false,
    down: bool = false,
};

// Frame contains all context needed by systems
const Frame = struct {
    world: *ecs.World,
    dt: f32,
    input: Input,
    time: f64,
    renderer: ?*engine.Renderer = null,
    camera: ?*engine.Camera = null,
};

// Game Systems
const PlayerSystem = struct {
    pub fn update(f: *Frame) void {
        var query = f.world.query(.{ Player, ecs.Transform, ecs.Physics });
        defer query.deinit();

        while (query.next()) |entity| {
            const player = f.world.getComponent(entity, Player).?;
            const transform = f.world.getComponent(entity, ecs.Transform).?;
            const physics = f.world.getComponent(entity, ecs.Physics).?;

            // Tank-style controls: left/right to rotate, up/down to move forward/backward
            const rotation_speed = 3.0; // radians per second

            // Reset velocity
            physics.velocity.x = 0;
            physics.velocity.y = 0;

            // Player rotation (left/right keys)
            if (f.input.left) {
                transform.rotation -= rotation_speed * f.dt;
            }
            if (f.input.right) {
                transform.rotation += rotation_speed * f.dt;
            }

            // Player forward/backward movement based on current rotation (up/down keys)
            var forward_input: f32 = 0.0;
            if (f.input.up) {
                forward_input = 1.0;
            }
            if (f.input.down) {
                forward_input = -1.0;
            }

            if (forward_input != 0.0) {
                // Calculate forward direction based on rotation
                const forward_x = @sin(transform.rotation);
                const forward_y = @cos(transform.rotation);

                // Set velocity in the forward direction
                physics.velocity.x = forward_x * forward_input * player.speed;
                physics.velocity.y = forward_y * forward_input * player.speed;
            }

            // Update camera to follow player
            if (f.camera) |cam| {
                cam.followTarget(transform.position.x, transform.position.y, f.dt, 8.0);
            }
        }
    }
};

const EnemySystem = struct {
    pub fn update(f: *Frame) void {
        // Find player position
        var player_pos: ?ecs.Transform = null;
        {
            var player_query = f.world.query(.{ Player, ecs.Transform });
            defer player_query.deinit();

            if (player_query.next()) |player_entity| {
                if (f.world.getComponent(player_entity, ecs.Transform)) |transform| {
                    player_pos = transform.*;
                }
            }
        }

        if (player_pos == null) return;

        // Update enemies to follow player
        var query = f.world.query(.{ Enemy, ecs.Transform, ecs.Physics });
        defer query.deinit();

        while (query.next()) |entity| {
            const enemy = f.world.getComponent(entity, Enemy).?;
            const transform = f.world.getComponent(entity, ecs.Transform).?;
            const physics = f.world.getComponent(entity, ecs.Physics).?;

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
    pub fn update(f: *Frame) void {
        var query = f.world.query(.{ ecs.Transform, ecs.Physics });
        defer query.deinit();

        while (query.next()) |entity| {
            const transform = f.world.getComponent(entity, ecs.Transform).?;
            const physics = f.world.getComponent(entity, ecs.Physics).?;

            // Integrate velocity -> position
            transform.position.x += physics.velocity.x * f.dt;
            transform.position.y += physics.velocity.y * f.dt;

            // World boundary constraints
            if (transform.position.x < WORLD_BOUNDS.min_x) transform.position.x = WORLD_BOUNDS.min_x;
            if (transform.position.x > WORLD_BOUNDS.max_x) transform.position.x = WORLD_BOUNDS.max_x;
            if (transform.position.y < WORLD_BOUNDS.min_y) transform.position.y = WORLD_BOUNDS.min_y;
            if (transform.position.y > WORLD_BOUNDS.max_y) transform.position.y = WORLD_BOUNDS.max_y;
        }
    }
};

const RenderSystem = struct {
    pub fn update(f: *Frame) void {
        if (f.renderer == null or f.camera == null) return;

        // Collect all renderable entities and sort by render order
        var query = f.world.query(.{ ecs.Transform, ecs.Sprite });
        defer query.deinit();

        // Create arrays to hold transforms and sprites (max 100 entities for now)
        var transforms: [100]engine.Transform = undefined;
        var sprites: [100]engine.SpriteRenderer = undefined;
        var count: usize = 0;

        // Background first (render behind everything)
        while (query.next()) |entity| {
            if (count >= 100) break; // Safety limit

            const ecs_transform = f.world.getComponent(entity, ecs.Transform).?;
            const ecs_sprite = f.world.getComponent(entity, ecs.Sprite).?;

            // Convert ECS transform to engine transform
            var engine_transform = engine.Transform.init(ecs_transform.position.x, ecs_transform.position.y);
            engine_transform.setScale(ecs_transform.scale.x, ecs_transform.scale.y);
            engine_transform.rotation = ecs_transform.rotation;

            // Create sprite renderer
            const sprite_renderer = engine.SpriteRenderer.init(ecs_sprite.texture_name);

            // Add to arrays (background entities should come first)
            if (std.mem.eql(u8, ecs_sprite.texture_name, "background")) {
                // Insert at beginning for background
                std.mem.copyBackwards(engine.Transform, transforms[1 .. count + 1], transforms[0..count]);
                std.mem.copyBackwards(engine.SpriteRenderer, sprites[1 .. count + 1], sprites[0..count]);
                transforms[0] = engine_transform;
                sprites[0] = sprite_renderer;
            } else {
                // Add at end for foreground entities
                transforms[count] = engine_transform;
                sprites[count] = sprite_renderer;
            }
            count += 1;
        }

        // Render all sprites with camera
        if (count > 0) {
            f.renderer.?.render(transforms[0..count], sprites[0..count], f.camera.?) catch |err| {
                std.debug.print("Render error: {}\n", .{err});
            };
        }
    }
};

// Game State
var current_input: Input = Input{};
var camera: engine.Camera = undefined;

// World boundaries (same as gameplay-test)
const WORLD_BOUNDS = struct {
    min_x: f32 = -4.0,
    max_x: f32 = 4.0,
    min_y: f32 = -4.0,
    max_y: f32 = 4.0,
}{};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Initialize engine
    const config = engine.EngineConfig{
        .window_width = 800,
        .window_height = 600,
        .window_title = "Gameplay Test 2 - ECS",
        .clear_color = .{ 0.1, 0.1, 0.1, 1.0 },
    };
    var engine_instance = try engine.Engine.init(allocator, config);
    defer engine_instance.deinit();

    // Load textures into asset bundle
    const player_texture = try engine.Texture.init("assets/textures/player.png");
    try engine_instance.getAssetBundle().textures.put(try allocator.dupe(u8, "player"), player_texture);

    const enemy_texture = try engine.Texture.init("assets/textures/enemy.png");
    try engine_instance.getAssetBundle().textures.put(try allocator.dupe(u8, "enemy"), enemy_texture);

    const background_texture = try engine.Texture.createBackgroundTexture();
    try engine_instance.getAssetBundle().textures.put(try allocator.dupe(u8, "background"), background_texture);

    std.debug.print("Loaded textures: player={}, enemy={}, background={}\n", .{ player_texture.id, enemy_texture.id, background_texture.id });

    // Initialize camera (zoomed out to see more world)
    camera = engine.Camera.init(0.0, 0.0, 0.30); // More zoomed out for better view

    // Initialize ECS world
    var world = ecs.World.init(allocator);
    defer world.deinit();

    // Create background entity (large, centered)
    const background = try world.createEntity();
    try world.addComponent(background, ecs.Transform{ .position = .{ .x = 0.0, .y = 0.0 }, .scale = .{ .x = 8.0, .y = 8.0 } });
    try world.addComponent(background, ecs.Sprite{ .texture_name = "background" });

    // Create player entity (centered in world coordinates)
    const player = try world.createEntity();
    try world.addComponent(player, Player{});
    try world.addComponent(player, ecs.Transform{ .position = .{ .x = 0.0, .y = 0.0 }, .scale = .{ .x = 0.5, .y = 0.5 } });
    try world.addComponent(player, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
    try world.addComponent(player, ecs.Sprite{ .texture_name = "player" });

    // Create enemy entities (spread around the world)
    for (0..5) |i| {
        const enemy = try world.createEntity();
        try world.addComponent(enemy, Enemy{});
        try world.addComponent(enemy, ecs.Transform{ .position = .{ .x = -2.0 + (@as(f32, @floatFromInt(i)) * 1.0), .y = 1.0 }, .scale = .{ .x = 0.4, .y = 0.4 } });
        try world.addComponent(enemy, ecs.Physics{ .velocity = .{ .x = 0.0, .y = 0.0 } });
        try world.addComponent(enemy, ecs.Sprite{ .texture_name = "enemy" });
    }

    std.debug.print("Gameplay Test 2 - ECS Systems Demo\n", .{});
    std.debug.print("Use WASD to move the green player\n", .{});
    std.debug.print("Red enemies will follow you\n", .{});
    std.debug.print("Press ESC to quit\n\n", .{});

    const c = @cImport({
        @cInclude("GLFW/glfw3.h");
    });

    // Use the engine's run method instead of manual game loop
    const GameApp = struct {
        world: *ecs.World,
        camera: *engine.Camera,

        pub fn update(self: *@This(), input: *const engine.Input, delta_time: f32) void {
            // Convert engine input to our input format
            current_input = Input{
                .left = input.isKeyDown(.a) or input.isKeyDown(.left),
                .right = input.isKeyDown(.d) or input.isKeyDown(.right),
                .up = input.isKeyDown(.w) or input.isKeyDown(.up),
                .down = input.isKeyDown(.s) or input.isKeyDown(.down),
            };

            // Create frame context
            var frame = Frame{
                .world = self.world,
                .dt = delta_time,
                .input = current_input,
                .time = c.glfwGetTime(),
                .camera = self.camera,
            };

            // Update simulation systems
            PlayerSystem.update(&frame);
            EnemySystem.update(&frame);
            PhysicsSystem.update(&frame);
        }

        pub fn render(self: *@This(), renderer: *engine.Renderer) !void {
            // Create frame context for rendering
            var frame = Frame{
                .world = self.world,
                .dt = 0.0, // Not used in rendering
                .input = current_input,
                .time = c.glfwGetTime(),
                .renderer = renderer,
                .camera = self.camera,
            };

            // Render all entities
            RenderSystem.update(&frame);
        }
    };

    var game_app = GameApp{
        .world = &world,
        .camera = &camera,
    };

    // Run the game using the engine's run method
    try engine_instance.run(GameApp, &game_app);
}
