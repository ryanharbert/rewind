const std = @import("std");
const window = @import("display/window.zig");
const assets = @import("display/assets.zig");

pub fn main() !void {
    std.debug.print("Starting Rewind...\n", .{});
    
    // Test asset loader
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    var asset_loader = assets.AssetLoader.init(allocator, "assets");
    
    // Try to load a test image
    if (asset_loader.loadImage("textures/player.png")) |image| {
        var loaded_image = image;
        defer loaded_image.deinit();
        std.debug.print("Loaded image: {}x{} with {} channels\n", .{ loaded_image.width, loaded_image.height, loaded_image.channels });
    } else |err| {
        std.debug.print("Failed to load image: {}\n", .{err});
    }
    
    var win = try window.Window.init(.{
        .width = 800,
        .height = 600,
        .title = "Rewind Game",
    });
    defer win.deinit();
    
    std.debug.print("Running Sokol window...\n", .{});
    
    // Sokol App takes control of the main loop
    win.run();
    
    std.debug.print("Rewind shutting down...\n", .{});
}