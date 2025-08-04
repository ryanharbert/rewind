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
            .init_cb = init_cb,
            .frame_cb = frame_cb,
            .cleanup_cb = cleanup_cb,
            .width = @intCast(self.config.width),
            .height = @intCast(self.config.height),
            .window_title = self.config.title.ptr,
            .swap_interval = if (self.config.vsync) 1 else 0,
        });
    }
};

// Sokol App callbacks - need export for C interop
export fn init_cb() void {
    sg.setup(.{
        .environment = sglue.environment(),
    });
}

export fn frame_cb() void {
    // Clear to a nice blue color  
    sg.beginPass(.{
        .action = .{
            .colors = .{
                .{ .load_action = .CLEAR, .clear_value = .{ .r = 0.2, .g = 0.4, .b = 0.8, .a = 1.0 } },
                .{}, .{}, .{},
            },
        },
        .swapchain = sglue.swapchain(),
    });
    
    sg.endPass();
    sg.commit();
}

export fn cleanup_cb() void {
    sg.shutdown();
}