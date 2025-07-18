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

const SimpleGameplayTest = struct {
    allocator: std.mem.Allocator,
    
    // Just one sprite in the center
    transform: Transform,
    sprite: SpriteRenderer,
    
    pub fn init(allocator: std.mem.Allocator, engine: *Engine) !SimpleGameplayTest {
        // Create the test sprite exactly like render-test does
        const test_texture = try Texture.createTestSprite();
        try engine.getAssetBundle().textures.put(try allocator.dupe(u8, "test_sprite"), test_texture);
        
        // Create one sprite in the center
        var transform = Transform.init(0.0, 0.0);
        transform.setScale(0.5, 0.5);
        const sprite = SpriteRenderer.init("test_sprite");
        
        std.debug.print("Created test sprite with texture ID: {}\n", .{test_texture.id});
        
        return SimpleGameplayTest{
            .allocator = allocator,
            .transform = transform,
            .sprite = sprite,
        };
    }
    
    pub fn deinit(self: *SimpleGameplayTest) void {
        _ = self;
    }
    
    pub fn update(self: *SimpleGameplayTest, input: *const Input, delta_time: f32) void {
        // Tank-style movement: left/right to rotate, up/down to move forward/backward
        const rotation_speed = 3.0; // radians per second
        const move_speed = 2.0;
        
        // Rotation
        if (input.isKeyDown(.a) or input.isKeyDown(.left)) {
            self.transform.rotate(-rotation_speed * delta_time);
        }
        if (input.isKeyDown(.d) or input.isKeyDown(.right)) {
            self.transform.rotate(rotation_speed * delta_time);
        }
        
        // Forward/backward movement based on current rotation
        var forward_input: f32 = 0.0;
        if (input.isKeyDown(.w) or input.isKeyDown(.up)) {
            forward_input = 1.0;
        }
        if (input.isKeyDown(.s) or input.isKeyDown(.down)) {
            forward_input = -1.0;
        }
        
        if (forward_input != 0.0) {
            // Calculate forward direction based on rotation
            const forward_x = @sin(self.transform.rotation);
            const forward_y = @cos(self.transform.rotation);
            
            const move_distance = forward_input * move_speed * delta_time;
            self.transform.translate(
                forward_x * move_distance,
                forward_y * move_distance
            );
        }
    }
    
    pub fn render(self: *SimpleGameplayTest, renderer: *Renderer) !void {
        // Render just one sprite
        var transforms = [_]Transform{self.transform};
        var sprites = [_]SpriteRenderer{self.sprite};
        
        try renderer.render(&transforms, &sprites);
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