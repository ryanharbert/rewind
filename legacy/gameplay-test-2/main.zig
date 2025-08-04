const std = @import("std");
const engine = @import("engine");
const ecs = @import("ecs");

// Import game-specific modules
const components = @import("components.zig");
const ecs_setup = @import("ecs_setup.zig");
const InputCommand = @import("input.zig").InputCommand;
const rendering = @import("rendering.zig");

// ECS types from single setup file
const GameSimulation = ecs_setup.GameSimulation;
const Frame = ecs_setup.Frame;

// Camera for rendering
var camera: engine.Camera = undefined;

// Current input commands buffer
var current_input_commands: std.ArrayList(InputCommand) = undefined;

// ECS-controlled simulation
var game_simulation: GameSimulation = undefined;

// Input conversion from engine input to simulation commands
fn convertInput(engine_input: *const engine.Input, commands: *std.ArrayList(InputCommand)) !void {
    commands.clearRetainingCapacity();
    
    // Convert engine key states to input commands
    if (engine_input.isKeyDown(.a) or engine_input.isKeyDown(.left)) {
        try commands.append(InputCommand.rotateLeft(1.0));
    }
    if (engine_input.isKeyDown(.d) or engine_input.isKeyDown(.right)) {
        try commands.append(InputCommand.rotateRight(1.0));
    }
    if (engine_input.isKeyDown(.w) or engine_input.isKeyDown(.up)) {
        try commands.append(InputCommand.moveForward(1.0));
    }
    if (engine_input.isKeyDown(.s) or engine_input.isKeyDown(.down)) {
        try commands.append(InputCommand.moveBackward(1.0));
    }
}

// Rendering system - extracts ECS data for presentation
const RenderingBridge = struct {
    pub fn renderEntities(frame: *Frame, renderer: *engine.Renderer, cam: *engine.Camera, allocator: std.mem.Allocator) !void {
        // Extract render data from ECS
        const render_sprites = try rendering.extractRenderData(frame, allocator);
        defer allocator.free(render_sprites);
        
        // Convert to engine format
        var transforms = try allocator.alloc(engine.Transform, render_sprites.len);
        defer allocator.free(transforms);
        var sprites = try allocator.alloc(engine.SpriteRenderer, render_sprites.len);
        defer allocator.free(sprites);
        
        for (render_sprites, 0..) |render_sprite, i| {
            var engine_transform = engine.Transform.init(render_sprite.position.x, render_sprite.position.y);
            engine_transform.setScale(render_sprite.scale.x, render_sprite.scale.y);
            engine_transform.rotation = render_sprite.rotation;
            
            transforms[i] = engine_transform;
            sprites[i] = engine.SpriteRenderer.init(render_sprite.texture_name);
        }
        
        // Render all sprites with camera
        if (transforms.len > 0) {
            try renderer.render(transforms, sprites, cam);
        }
    }
    
    pub fn updateCameraToFollowPlayer(frame: *Frame, cam: *engine.Camera, dt: f32) void {
        var player_query = frame.query(&[_]type{ components.Player, components.Transform }) catch return;
        defer player_query.deinit();
        
        if (player_query.next()) |player_entity| {
            if (frame.getComponent(player_entity, components.Transform)) |transform| {
                cam.followTarget(transform.position.x, transform.position.y, dt, 8.0);
            }
        }
    }
};

pub fn main() !void {
    // Main allocator for engine and presentation layer
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Initialize engine
    const config = engine.EngineConfig{
        .window_width = 800,
        .window_height = 600,
        .window_title = "Gameplay Test 2 - Generic ECS",
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
    
    std.debug.print("Loaded textures: player={}, enemy={}, background={}\n", 
        .{ player_texture.id, enemy_texture.id, background_texture.id });
    
    // Initialize camera
    camera = engine.Camera.init(0.0, 0.0, 0.25);
    
    // Initialize input command buffer (uses main allocator for presentation layer)
    current_input_commands = std.ArrayList(InputCommand).init(allocator);
    defer current_input_commands.deinit();
    
    // Separate allocator for simulation  
    var sim_gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = sim_gpa.detectLeaks();
        if (leaked) {
            std.debug.print("⚠️ Simulation memory leaked!\n", .{});
        } else {
            std.debug.print("✅ Simulation memory clean\n", .{});
        }
        _ = sim_gpa.deinit();
    }
    const sim_allocator = sim_gpa.allocator();
    
    // Initialize ECS simulation - it controls system execution
    game_simulation = GameSimulation.init(sim_allocator);
    defer game_simulation.deinit();
    
    // Initialize all systems through simulation controller
    const c = @cImport({
        @cInclude("GLFW/glfw3.h");
    });
    const init_time = c.glfwGetTime();
    try game_simulation.initSystems(init_time);
    
    std.debug.print("Generic ECS Simulation - Gameplay Test 2\n", .{});
    std.debug.print("Use WASD or arrow keys to control the player\n", .{});
    std.debug.print("Left/Right: Rotate, Up/Down: Move forward/backward\n", .{});
    std.debug.print("Red enemies will follow you\n", .{});
    std.debug.print("Press ESC to quit\n\n", .{});
    
    // Game application using engine's run method
    const GameApp = struct {
        input_commands: *std.ArrayList(InputCommand),
        cam: *engine.Camera,
        frame_number: u64 = 0,
        allocator: std.mem.Allocator,
        simulation: *GameSimulation,
        
        pub fn update(self: *@This(), input: *const engine.Input, delta_time: f32) void {
            // Convert engine input to simulation commands
            convertInput(input, self.input_commands) catch {
                std.debug.print("Error converting input\n", .{});
                return;
            };
            
            // ECS controls system execution order deterministically
            const time = c.glfwGetTime();
            self.simulation.update(self.input_commands.items, delta_time, time);
            self.frame_number += 1;
            
            // Update camera to follow player (presentation layer)
            RenderingBridge.updateCameraToFollowPlayer(self.simulation.getCurrentFrame(), self.cam, delta_time);
        }
        
        pub fn render(self: *@This(), renderer: *engine.Renderer) !void {
            // Extract simulation data and render (presentation layer)
            try RenderingBridge.renderEntities(self.simulation.getCurrentFrame(), renderer, self.cam, self.allocator);
        }
    };
    
    var game_app = GameApp{
        .input_commands = &current_input_commands,
        .cam = &camera,
        .allocator = allocator,
        .simulation = &game_simulation,
    };
    
    // Run the game
    try engine_instance.run(GameApp, &game_app);
}