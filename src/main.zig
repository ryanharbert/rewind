const std = @import("std");
const window = @import("display/window.zig");
const assets = @import("display/assets.zig");
const renderer = @import("display/renderer.zig");
const camera = @import("display/camera.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var sprite_renderer: renderer.SpriteRenderer = undefined;
var main_camera: camera.Camera = undefined;
var player_texture_id: u32 = 0;
var enemy_texture_id: u32 = 0;

pub fn main() !void {
    std.debug.print("Starting Rewind...\n", .{});
    
    var win = try window.Window.init(.{
        .width = 800,
        .height = 600,
        .title = "Rewind Game",
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
    });
    defer win.deinit();
    
    std.debug.print("Running Sokol window...\n", .{});
    
    // Sokol App takes control of the main loop
    win.run();
    
    std.debug.print("Rewind shutting down...\n", .{});
}

// Sokol callbacks that will load assets and render sprites
export fn init() void {
    const sg = @import("sokol").gfx;
    const sglue = @import("sokol").glue;
    
    // First, setup sokol graphics
    sg.setup(.{
        .environment = sglue.environment(),
    });
    
    const allocator = gpa.allocator();
    
    // Initialize camera
    main_camera = camera.Camera.init(800, 600);
    
    // Initialize sprite renderer
    sprite_renderer = renderer.SpriteRenderer.init(allocator) catch |err| {
        std.debug.print("Failed to init sprite renderer: {}\n", .{err});
        return;
    };
    
    var asset_loader = assets.AssetLoader.init(allocator, "assets");
    
    // Load player texture
    if (asset_loader.loadImage("textures/player.png")) |image| {
        var loaded_image = image;
        defer loaded_image.deinit();
        player_texture_id = sprite_renderer.loadTexture(loaded_image) catch 0;
        std.debug.print("Loaded player texture: {}x{}\n", .{ loaded_image.width, loaded_image.height });
    } else |err| {
        std.debug.print("Failed to load player: {}\n", .{err});
    }
    
    // Load enemy texture
    if (asset_loader.loadImage("textures/enemy.png")) |image| {
        var loaded_image = image;
        defer loaded_image.deinit();
        enemy_texture_id = sprite_renderer.loadTexture(loaded_image) catch 0;
        std.debug.print("Loaded enemy texture: {}x{}\n", .{ loaded_image.width, loaded_image.height });
    } else |err| {
        std.debug.print("Failed to load enemy: {}\n", .{err});
    }
}

export fn frame() void {
    const sg = @import("sokol").gfx;
    const sglue = @import("sokol").glue;
    
    // Clear with camera background color and setup render pass
    sg.beginPass(.{
        .swapchain = sglue.swapchain(),
        .action = .{
            .colors = .{
                .{ .load_action = .CLEAR, .clear_value = .{ 
                    .r = main_camera.background_color.r, 
                    .g = main_camera.background_color.g, 
                    .b = main_camera.background_color.b, 
                    .a = main_camera.background_color.a 
                } },
                .{}, .{}, .{},
            },
        },
    });
    
    // Get projection matrix from camera
    const projection = main_camera.getProjectionMatrix();
    
    // Draw sprites side by side - try with high contrast colors to ensure visibility
    if (player_texture_id >= 0) {
        // First sprite - bright yellow (should be very visible against blue)
        sprite_renderer.drawSprite(.{
            .position = .{ .x = 300, .y = 200 },
            .size = .{ .x = 128, .y = 128 },
            .color = .{ .r = 1, .g = 1, .b = 0, .a = 1 }, // Bright yellow
            .texture_id = 0,
        }) catch {};
        
        // Second sprite - bright magenta (also very visible)
        sprite_renderer.drawSprite(.{
            .position = .{ .x = 450, .y = 200 },
            .size = .{ .x = 128, .y = 128 },
            .color = .{ .r = 1, .g = 0, .b = 1, .a = 1 }, // Bright magenta
            .texture_id = 0,
        }) catch {};
    }
    
    // Render all sprites
    sprite_renderer.render(projection);
    
    sg.endPass();
    sg.commit();
}

export fn cleanup() void {
    sprite_renderer.deinit();
}

