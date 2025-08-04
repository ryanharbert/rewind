const std = @import("std");
const Frame = @import("frame.zig").Frame;
const InputCommand = @import("input_commands.zig").InputCommand;

// Input history for future rollback support
pub const InputHistory = struct {
    commands: std.ArrayList([]InputCommand),
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator) InputHistory {
        return InputHistory{
            .commands = std.ArrayList([]InputCommand).init(allocator),
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *InputHistory) void {
        for (self.commands.items) |frame_commands| {
            self.allocator.free(frame_commands);
        }
        self.commands.deinit();
    }
    
    pub fn addFrame(self: *InputHistory, commands: []const InputCommand) !void {
        const owned_commands = try self.allocator.dupe(InputCommand, commands);
        try self.commands.append(owned_commands);
    }
};

// System definition
pub const System = struct {
    name: []const u8,
    initFn: *const fn(frame: *Frame) anyerror!void,
    updateFn: *const fn(frame: *Frame) void,
    enableFn: ?*const fn(frame: *Frame) void = null,
    disableFn: ?*const fn(frame: *Frame) void = null,
    enabled: bool = true,
};

// System registry
pub const SystemRegistry = struct {
    systems: []System,
    input_history: InputHistory,
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator, systems: []System) SystemRegistry {
        return SystemRegistry{
            .systems = systems,
            .input_history = InputHistory.init(allocator),
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *SystemRegistry) void {
        self.input_history.deinit();
    }
    
    pub fn initSystems(self: *SystemRegistry, frame: *Frame) !void {
        for (self.systems) |*system| {
            if (system.enabled) {
                try system.initFn(frame);
            }
        }
    }
    
    pub fn update(self: *SystemRegistry, frame: *Frame) void {
        for (self.systems) |*system| {
            if (system.enabled) {
                system.updateFn(frame);
            }
        }
    }
    
    pub fn addInputFrame(self: *SystemRegistry, commands: []const InputCommand) !void {
        try self.input_history.addFrame(commands);
    }
    
    pub fn enableSystem(self: *SystemRegistry, name: []const u8, frame: *Frame) void {
        for (self.systems) |*system| {
            if (std.mem.eql(u8, system.name, name) and !system.enabled) {
                system.enabled = true;
                if (system.enableFn) |enableFn| {
                    enableFn(frame);
                }
            }
        }
    }
    
    pub fn disableSystem(self: *SystemRegistry, name: []const u8, frame: *Frame) void {
        for (self.systems) |*system| {
            if (std.mem.eql(u8, system.name, name) and system.enabled) {
                system.enabled = false;
                if (system.disableFn) |disableFn| {
                    disableFn(frame);
                }
            }
        }
    }
};