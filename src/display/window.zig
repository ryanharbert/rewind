const std = @import("std");
const sokol = @import("sokol");
const sapp = sokol.app;
const sg = sokol.gfx;
const sglue = sokol.glue;

pub const WindowConfig = struct {
    width: u32 = 800,
    height: u32 = 600,
    title: [:0]const u8 = "Rewind Game",
    vsync: bool = true,
    init_cb: ?*const fn() callconv(.C) void = null,
    frame_cb: ?*const fn() callconv(.C) void = null,
    cleanup_cb: ?*const fn() callconv(.C) void = null,
};

pub const Window = struct {
    config: WindowConfig,
    
    pub fn init(config: WindowConfig) !Window {
        // Sokol App will be initialized via callbacks
        return Window{
            .config = config,
        };
    }
    
    pub fn deinit(self: *Window) void {
        _ = self;
        // Sokol App cleanup happens automatically
    }
    
    pub fn shouldClose(self: *const Window) bool {
        _ = self;
        return sapp.shouldQuit();
    }
    
    pub fn pollEvents(self: *Window) void {
        _ = self;
        // Sokol App handles events automatically
    }
    
    pub fn present(self: *Window) void {
        _ = self;
        sg.commit();
    }
    
    pub fn getSize(self: *const Window) struct { width: u32, height: u32 } {
        _ = self;
        return .{ 
            .width = @intCast(sapp.width()), 
            .height = @intCast(sapp.height()) 
        };
    }
    
    pub fn run(self: *Window) void {
        sapp.run(.{
            .init_cb = self.config.init_cb orelse default_init_cb,
            .frame_cb = self.config.frame_cb orelse default_frame_cb,
            .cleanup_cb = self.config.cleanup_cb orelse default_cleanup_cb,
            .width = @intCast(self.config.width),
            .height = @intCast(self.config.height),
            .window_title = self.config.title.ptr,
            .swap_interval = if (self.config.vsync) 1 else 0,
        });
    }
};

// Default callbacks if none provided
export fn default_init_cb() void {
    sg.setup(.{
        .environment = sglue.environment(),
    });
}

export fn default_frame_cb() void {
    // Clear to a nice blue color  
    sg.beginPass(.{
        .swapchain = sglue.swapchain(),
        .action = .{
            .colors = .{
                .{ .load_action = .CLEAR, .clear_value = .{ .r = 0.2, .g = 0.4, .b = 0.8, .a = 1.0 } },
                .{}, .{}, .{},
            },
        },
    });
    
    sg.endPass();
    sg.commit();
}

export fn default_cleanup_cb() void {
    sg.shutdown();
}