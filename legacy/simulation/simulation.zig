const std = @import("std");
const Frame = @import("frame.zig").Frame;
const State = @import("frame.zig").State;
const InputCommand = @import("input_commands.zig").InputCommand;
const SystemRegistry = @import("system.zig").SystemRegistry;
const System = @import("system.zig").System;

pub const Simulation = struct {
    system_registry: SystemRegistry,
    state: State,
    current_frame: u64,
    start_time: f64,
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator, systems: []System) Simulation {
        return Simulation{
            .system_registry = SystemRegistry.init(allocator, systems),
            .state = State.init(allocator),
            .current_frame = 0,
            .start_time = 0.0,
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Simulation) void {
        self.state.deinit();
        self.system_registry.deinit();
    }
    
    pub fn initSystems(self: *Simulation, time: f64) !void {
        self.start_time = time;
        
        var frame = Frame{
            .state = &self.state,
            .dt = 0.0, // No delta time for init
            .time = time,
            .frame_number = 0,
            .input = &[_]InputCommand{}, // Empty input for init
        };
        
        try self.system_registry.initSystems(&frame);
    }
    
    pub fn update(self: *Simulation, input_commands: []const InputCommand, dt: f32, time: f64) !void {
        var frame = Frame{
            .state = &self.state,
            .dt = dt,
            .time = time,
            .frame_number = self.current_frame,
            .input = input_commands,
        };
        
        try self.system_registry.addInputFrame(input_commands);
        self.system_registry.update(&frame);
        self.current_frame += 1;
    }
    
    pub fn getState(self: *Simulation) *State {
        return &self.state;
    }
};