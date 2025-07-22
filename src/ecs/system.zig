// Generic system framework
pub const System = struct {
    name: []const u8,
    initFn: ?*const fn (ctx: anytype) anyerror!void = null,
    updateFn: *const fn (ctx: anytype) void,
    enableFn: ?*const fn (ctx: anytype) void = null,
    disableFn: ?*const fn (ctx: anytype) void = null,
    enabled: bool = true,
};

pub fn SystemRegistry(comptime ContextType: type) type {
    return struct {
        const Self = @This();
        
        systems: []System,
        
        pub fn init(systems: []System) Self {
            return Self{
                .systems = systems,
            };
        }
        
        pub fn initSystems(self: *Self, context: ContextType) !void {
            for (self.systems) |*system| {
                if (system.enabled and system.initFn != null) {
                    try system.initFn.?(context);
                }
            }
        }
        
        pub fn updateSystems(self: *Self, context: ContextType) void {
            for (self.systems) |*system| {
                if (system.enabled) {
                    system.updateFn(context);
                }
            }
        }
        
        pub fn enableSystem(self: *Self, name: []const u8, context: ContextType) void {
            for (self.systems) |*system| {
                if (std.mem.eql(u8, system.name, name) and !system.enabled) {
                    system.enabled = true;
                    if (system.enableFn) |enableFn| {
                        enableFn(context);
                    }
                }
            }
        }
        
        pub fn disableSystem(self: *Self, name: []const u8, context: ContextType) void {
            for (self.systems) |*system| {
                if (std.mem.eql(u8, system.name, name) and system.enabled) {
                    system.enabled = false;
                    if (system.disableFn) |disableFn| {
                        disableFn(context);
                    }
                }
            }
        }
    };
}

const std = @import("std");