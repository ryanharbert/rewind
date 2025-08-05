const std = @import("std");
const rewind = @import("rewind.zig");

// Game state
var player_texture_id: u32 = 0;
var enemy_texture_id: u32 = 0;

pub fn main() !void {
    std.debug.print("Starting Rewind...\n", .{});
    
    // Create engine with config and callbacks
    var engine = try rewind.Rewind.init(.{
        .window_width = 800,
        .window_height = 600,
        .window_title = "Rewind Game",
        .asset_path = "assets",
        .vsync = true,
    }, .{
        .init = gameInit,
        .update = gameUpdate,
        .render = gameRender,
        .cleanup = gameCleanup,
    });
    defer engine.deinit();
    
    std.debug.print("Running Rewind engine...\n", .{});
    
    // Run the engine (this takes control of the main loop)
    engine.run();
    
    std.debug.print("Rewind shutting down...\n", .{});
}

// Game callbacks
fn gameInit(engine: *rewind.Rewind) void {
    std.debug.print("Game initializing...\n", .{});
    
    // Load textures
    player_texture_id = engine.loadTexture("textures/player.png") catch blk: {
        std.debug.print("Failed to load player texture\n", .{});
        break :blk 0;
    };
    
    enemy_texture_id = engine.loadTexture("textures/enemy.png") catch blk: {
        std.debug.print("Failed to load enemy texture\n", .{});
        break :blk 0;
    };
    
    std.debug.print("Loaded textures: player={}, enemy={}\n", .{ player_texture_id, enemy_texture_id });
}

fn gameUpdate(engine: *rewind.Rewind, dt: f32) void {
    // Game logic goes here
    _ = engine;
    _ = dt;
}

fn gameRender(engine: *rewind.Rewind) void {
    // Draw sprites side by side with high contrast colors
    if (player_texture_id >= 0) { // Texture ID 0 is valid
        // First sprite - bright yellow
        engine.drawSprite(.{
            .position = .{ .x = 300, .y = 200 },
            .size = .{ .x = 128, .y = 128 },
            .color = .{ .r = 1, .g = 1, .b = 0, .a = 1 },
            .texture_id = 0,
        }) catch {};
        
        // Second sprite - bright magenta  
        engine.drawSprite(.{
            .position = .{ .x = 450, .y = 200 },
            .size = .{ .x = 128, .y = 128 },
            .color = .{ .r = 1, .g = 0, .b = 1, .a = 1 },
            .texture_id = 0,
        }) catch {};
    }
}

fn gameCleanup(engine: *rewind.Rewind) void {
    std.debug.print("Game cleanup\n", .{});
    _ = engine;
}

