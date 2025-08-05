const std = @import("std");
const window = @import("display/window.zig");
const assets = @import("display/assets.zig");
const renderer = @import("display/renderer.zig");
const camera = @import("display/camera.zig");

pub const Config = struct {
    // Display settings
    window_width: u32 = 800,
    window_height: u32 = 600,
    window_title: [:0]const u8 = "Rewind Game",
    asset_path: []const u8 = "assets",
    vsync: bool = true,
    
    // Simulation settings
    simulation_framerate: u32 = 60, // Fixed tick rate for deterministic ECS
};

pub const GameCallbacks = struct {
    init: ?*const fn(*Rewind) void = null,
    update: ?*const fn(*Rewind, f32) void = null, // delta time
    render: ?*const fn(*Rewind) void = null,
    cleanup: ?*const fn(*Rewind) void = null,
};

pub const Rewind = struct {
    allocator: std.mem.Allocator,
    config: Config,
    callbacks: GameCallbacks,
    
    // Internal systems
    gpa: std.heap.GeneralPurposeAllocator(.{}),
    win: window.Window,
    sprite_renderer: ?renderer.SpriteRenderer,
    asset_loader: ?assets.AssetLoader,
    main_camera: camera.Camera,
    
    // No timing state needed - vsync handles it
    
    pub fn init(config: Config, callbacks: GameCallbacks) !Rewind {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        
        // Initialize camera
        const main_camera = camera.Camera.init(@floatFromInt(config.window_width), @floatFromInt(config.window_height));
        
        // Initialize window with engine callbacks
        const win = try window.Window.init(.{
            .width = config.window_width,
            .height = config.window_height,
            .title = config.window_title,
            .vsync = config.vsync,
            .init_cb = engineInit,
            .frame_cb = engineFrame, 
            .cleanup_cb = engineCleanup,
        });
        
        const rewind_engine: Rewind = .{
            .allocator = allocator,
            .config = config,
            .callbacks = callbacks,
            .gpa = gpa,
            .win = win,
            .sprite_renderer = null, // Will be initialized in engineInit
            .asset_loader = null,   // Will be initialized in engineInit
            .main_camera = main_camera,
        };
        
        return rewind_engine;
    }
    
    pub fn run(self: *Rewind) void {
        // Store reference to engine for callbacks
        engine_instance = self;
        self.win.run();
    }
    
    pub fn deinit(self: *Rewind) void {
        if (self.sprite_renderer) |*renderer_ref| {
            renderer_ref.deinit();
        }
        _ = self.gpa.deinit();
    }
    
    // Public API for game logic
    pub fn drawSprite(self: *Rewind, sprite: renderer.Sprite) !void {
        if (self.sprite_renderer) |*renderer_ref| {
            try renderer_ref.drawSprite(sprite);
        }
    }
    
    pub fn loadTexture(self: *Rewind, relative_path: []const u8) !u32 {
        if (self.asset_loader) |*asset_ref| {
            if (self.sprite_renderer) |*renderer_ref| {
                const image = try asset_ref.loadImage(relative_path);
                var loaded_image = image;
                defer loaded_image.deinit();
                return renderer_ref.loadTexture(loaded_image);
            }
        }
        return 0;
    }
    
    pub fn getCamera(self: *Rewind) *camera.Camera {
        return &self.main_camera;
    }
    
    pub fn setBackgroundColor(self: *Rewind, color: camera.Color) void {
        self.main_camera.setBackgroundColor(color);
    }
    
    pub fn getWindowSize(self: *const Rewind) struct { width: u32, height: u32 } {
        return self.win.getSize();
    }
};

// Global engine instance for sokol callbacks
var engine_instance: ?*Rewind = null;

// Engine callback functions called by sokol
export fn engineInit() void {
    const sg = @import("sokol").gfx;
    const sglue = @import("sokol").glue;
    
    if (engine_instance) |engine| {
        // Setup sokol graphics
        sg.setup(.{
            .environment = sglue.environment(),
        });
        
        // Get allocator from the engine's GPA
        const allocator = engine.gpa.allocator();
        
        // Initialize sprite renderer
        engine.sprite_renderer = renderer.SpriteRenderer.init(allocator) catch |err| {
            std.debug.print("Failed to init sprite renderer: {}\n", .{err});
            return;
        };
        
        // Initialize asset loader
        engine.asset_loader = assets.AssetLoader.init(allocator, engine.config.asset_path);
        
        // Call user init callback
        if (engine.callbacks.init) |init_fn| {
            init_fn(engine);
        }
    }
}

export fn engineFrame() void {
    const sg = @import("sokol").gfx;
    const sglue = @import("sokol").glue;
    
    if (engine_instance) |engine| {
        // Calculate dt from the refresh rate that vsync is syncing to
        // Most displays are 60Hz, some are 120Hz, 144Hz, etc.
        // Since vsync is controlling timing, we get 1/refresh_rate per frame
        const dt: f32 = 1.0 / @as(f32, @floatFromInt(engine.config.simulation_framerate));
        
        // Begin render pass with camera background
        sg.beginPass(.{
            .swapchain = sglue.swapchain(),
            .action = .{
                .colors = .{
                    .{ .load_action = .CLEAR, .clear_value = .{ 
                        .r = engine.main_camera.background_color.r, 
                        .g = engine.main_camera.background_color.g, 
                        .b = engine.main_camera.background_color.b, 
                        .a = engine.main_camera.background_color.a 
                    } },
                    .{}, .{}, .{},
                },
            },
        });
        
        // Call user update callback
        if (engine.callbacks.update) |update_fn| {
            update_fn(engine, @floatCast(dt));
        }
        
        // Call user render callback
        if (engine.callbacks.render) |render_fn| {
            render_fn(engine);
        }
        
        // Render all sprites with camera projection
        if (engine.sprite_renderer) |*renderer_ref| {
            const projection = engine.main_camera.getProjectionMatrix();
            renderer_ref.render(projection);
        }
        
        sg.endPass();
        sg.commit();
    }
}

export fn engineCleanup() void {
    if (engine_instance) |engine| {
        // Call user cleanup callback
        if (engine.callbacks.cleanup) |cleanup_fn| {
            cleanup_fn(engine);
        }
        
        const sg = @import("sokol").gfx;
        sg.shutdown();
    }
}