// ECS Simulation Controller - manages deterministic execution
const std = @import("std");
const EntityManager = @import("entity.zig").EntityManager;
const ComponentManager = @import("component.zig").ComponentManager;
const World = @import("world.zig").World;

// Generic simulation that takes game-specific types at compile time
pub fn Simulation(
    comptime component_types: []const type,
    comptime InputType: type,
    comptime systems: anytype, // Compile-time system definitions
) type {
    const GameWorld = World(component_types);
    
    return struct {
        const Self = @This();
        
        allocator: std.mem.Allocator,
        world: GameWorld,
        frame_number: u64,
        time: f64,
        
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .world = GameWorld.init(allocator),
                .frame_number = 0,
                .time = 0.0,
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.world.deinit();
        }
        
        // Initialize all systems (called once at startup)
        pub fn initSystems(self: *Self, initial_time: f64) !void {
            const frame = Frame{
                .world = &self.world,
                .dt = 0.016, // Dummy dt for init
                .time = initial_time,
                .frame_number = 0,
                .input = &[_]InputType{},
            };
            
            // Call each system's init function - compile-time unrolled
            inline for (systems) |system| {
                try system.init(frame);
            }
            
            self.time = initial_time;
        }
        
        // Update simulation by one frame - deterministic execution
        pub fn update(self: *Self, input: []const InputType, dt: f32, current_time: f64) void {
            const frame = Frame{
                .world = &self.world,
                .dt = dt,
                .time = current_time,
                .frame_number = self.frame_number,
                .input = input,
            };
            
            // Execute systems in deterministic order - compile-time unrolled
            inline for (systems) |system| {
                system.update(frame);
            }
            
            self.frame_number += 1;
            self.time = current_time;
        }
        
        // Get world access for rendering (mutable for queries)
        pub fn getWorld(self: *Self) *GameWorld {
            return &self.world;
        }
        
        // Frame context passed to systems
        const Frame = struct {
            world: *GameWorld,
            dt: f32,
            time: f64,
            frame_number: u64,
            input: []const InputType,
        };
    };
}