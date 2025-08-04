const std = @import("std");

// Engine imports
const Engine = @import("engine").Engine;
const EngineConfig = @import("engine").EngineConfig;
const Input = @import("engine").Input;
const math = @import("engine").math;
const Transform = @import("engine").Transform;
const SpriteRenderer = @import("engine").SpriteRenderer;
const Renderer = @import("engine").Renderer;
const Texture = @import("engine").Texture;
const Camera = @import("engine").Camera;

const SimpleGameplayTest = struct {
    allocator: std.mem.Allocator,
    
    // Player
    player_transform: Transform,
    player_sprite: SpriteRenderer,
    
    // Enemy
    enemy_transform: Transform,
    enemy_sprite: SpriteRenderer,
    
    // Camera
    camera: Camera,
    
    // Background
    background_transform: Transform,
    background_sprite: SpriteRenderer,
    
    // World boundaries
    world_bounds: struct { 
        min_x: f32, 
        max_x: f32, 
        min_y: f32, 
        max_y: f32 
    } = .{ .min_x = -4.0, .max_x = 4.0, .min_y = -4.0, .max_y = 4.0 },
    
    pub fn init(allocator: std.mem.Allocator, engine: *Engine) !SimpleGameplayTest {
        // Load player texture
        const player_texture = try Texture.init("assets/textures/player.png");
        try engine.getAssetBundle().textures.put(try allocator.dupe(u8, "player"), player_texture);
        
        // Load enemy texture
        const enemy_texture = try Texture.init("assets/textures/enemy.png");
        try engine.getAssetBundle().textures.put(try allocator.dupe(u8, "enemy"), enemy_texture);
        
        // Create background texture
        const background_texture = try Texture.createBackgroundTexture();
        try engine.getAssetBundle().textures.put(try allocator.dupe(u8, "background"), background_texture);
        
        // Create player in center
        var player_transform = Transform.init(0.0, 0.0);
        player_transform.setScale(0.5, 0.5);
        const player_sprite = SpriteRenderer.init("player");
        
        // Create enemy at a different position
        var enemy_transform = Transform.init(1.0, 1.0);
        enemy_transform.setScale(0.4, 0.4);
        const enemy_sprite = SpriteRenderer.init("enemy");
        
        // Create large background
        var background_transform = Transform.init(0.0, 0.0);
        background_transform.setScale(8.0, 8.0); // Large background
        const background_sprite = SpriteRenderer.init("background");
        
        // Create camera with initial zoom (zoomed out to see more world)
        const camera = Camera.init(0.0, 0.0, 0.5);
        
        // Use default world boundaries
        
        std.debug.print("Created player with texture ID: {}\n", .{player_texture.id});
        std.debug.print("Created enemy with texture ID: {}\n", .{enemy_texture.id});
        std.debug.print("Created background with texture ID: {}\n", .{background_texture.id});
        
        return SimpleGameplayTest{
            .allocator = allocator,
            .player_transform = player_transform,
            .player_sprite = player_sprite,
            .enemy_transform = enemy_transform,
            .enemy_sprite = enemy_sprite,
            .camera = camera,
            .background_transform = background_transform,
            .background_sprite = background_sprite,
        };
    }
    
    pub fn deinit(self: *SimpleGameplayTest) void {
        _ = self;
    }
    
    pub fn update(self: *SimpleGameplayTest, input: *const Input, delta_time: f32) void {
        // Player controls - Tank-style movement: left/right to rotate, up/down to move forward/backward
        const rotation_speed = 3.0; // radians per second
        const move_speed = 2.0;
        
        // Player rotation
        if (input.isKeyDown(.a) or input.isKeyDown(.left)) {
            self.player_transform.rotate(-rotation_speed * delta_time);
        }
        if (input.isKeyDown(.d) or input.isKeyDown(.right)) {
            self.player_transform.rotate(rotation_speed * delta_time);
        }
        
        // Player forward/backward movement based on current rotation
        var forward_input: f32 = 0.0;
        if (input.isKeyDown(.w) or input.isKeyDown(.up)) {
            forward_input = 1.0;
        }
        if (input.isKeyDown(.s) or input.isKeyDown(.down)) {
            forward_input = -1.0;
        }
        
        if (forward_input != 0.0) {
            // Calculate forward direction based on rotation
            const forward_x = @sin(self.player_transform.rotation);
            const forward_y = @cos(self.player_transform.rotation);
            
            const move_distance = forward_input * move_speed * delta_time;
            const new_x = self.player_transform.position.toFloat().x + forward_x * move_distance;
            const new_y = self.player_transform.position.toFloat().y + forward_y * move_distance;
            
            // Constrain to world boundaries
            const constrained_x = @min(@max(new_x, self.world_bounds.min_x), self.world_bounds.max_x);
            const constrained_y = @min(@max(new_y, self.world_bounds.min_y), self.world_bounds.max_y);
            
            self.player_transform.setPosition(constrained_x, constrained_y);
        }
        
        // Enemy AI - follow the player
        const enemy_speed = 1.0; // Slower than player
        const stop_distance = 0.3; // Stop following when this close
        
        const player_pos = self.player_transform.position.toFloat();
        const enemy_pos = self.enemy_transform.position.toFloat();
        
        // Calculate distance to player
        const dx = player_pos.x - enemy_pos.x;
        const dy = player_pos.y - enemy_pos.y;
        const distance = @sqrt(dx * dx + dy * dy);
        
        // Only move if not too close to player
        if (distance > stop_distance) {
            // Normalize direction vector
            const dir_x = dx / distance;
            const dir_y = dy / distance;
            
            // Move towards player
            const move_distance = enemy_speed * delta_time;
            self.enemy_transform.translate(
                dir_x * move_distance,
                dir_y * move_distance
            );
            
            // Face the player (optional - makes enemy point towards player)
            self.enemy_transform.rotation = std.math.atan2(dx, dy);
        }
        
        // Camera controls and following
        const player_position = self.player_transform.position.toFloat();
        
        // Camera zoom controls
        if (input.isKeyDown(.q)) {
            self.camera.adjustZoom(-1.0 * delta_time); // Zoom out
        }
        if (input.isKeyDown(.e)) {
            self.camera.adjustZoom(1.0 * delta_time); // Zoom in
        }
        
        // Make camera follow player smoothly
        self.camera.followTarget(player_position.x, player_position.y, delta_time, 8.0);
        
        // Update camera aspect ratio (in case window was resized)
        // This will be handled by the renderer during rendering
    }
    
    pub fn render(self: *SimpleGameplayTest, renderer: *Renderer) !void {
        // Render background, player, and enemy sprites with camera
        // Background first (drawn behind everything)
        var transforms = [_]Transform{self.background_transform, self.player_transform, self.enemy_transform};
        var sprites = [_]SpriteRenderer{self.background_sprite, self.player_sprite, self.enemy_sprite};
        
        try renderer.render(&transforms, &sprites, &self.camera);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create engine
    const config = EngineConfig{
        .window_title = "Gameplay Test - Minimal",
        .clear_color = .{ 0.1, 0.1, 0.1, 1.0 },
    };
    
    var engine = try Engine.init(allocator, config);
    defer engine.deinit();

    // Create simple test
    var game = try SimpleGameplayTest.init(allocator, &engine);
    defer game.deinit();

    std.debug.print("Tank Movement Test Started!\n", .{});
    std.debug.print("A/D or Left/Right: Rotate\n", .{});
    std.debug.print("W/S or Up/Down: Move Forward/Backward\n", .{});
    std.debug.print("Press ESC to exit\n", .{});

    // Run the game
    try engine.run(SimpleGameplayTest, &game);
}