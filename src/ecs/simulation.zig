// ECS Simulation - clean compile-time setup
const std = @import("std");
const EntityManager = @import("entity.zig").EntityManager;
const ComponentManager = @import("component.zig").ComponentManager;
const Query = @import("query.zig").Query;
const EntityID = @import("entity.zig").EntityID;

pub const Simulation = struct {
    // Compile function - creates a complete simulation type
    pub fn compile(comptime config: anytype) type {
        const component_types = config.components;
        const InputType = config.input;
        const systems = config.systems;
        
        const ComponentMgr = ComponentManager(component_types);
        
        // Generate the Frame type for this simulation
        const FrameType = struct {
            // ECS state - copyable for rollback
            entities: EntityManager,
            components: ComponentMgr,
            
            // Frame context - everything systems need
            deltaTime: f32,
            time: f64,
            frame_number: u64,
            input: []const InputType,
            
            const Self = @This();
            
            // Primary ECS API - everything goes through Frame
            pub fn createEntity(self: *Self) EntityID {
                const entity_id = self.entities.createEntity();
                self.components.registerEntity(entity_id) catch {
                    return 0; // Invalid entity
                };
                return entity_id;
            }
            
            pub fn addComponent(self: *Self, entity: EntityID, component: anytype) void {
                self.components.addComponent(entity, component) catch {};
            }
            
            pub fn getComponent(self: *Self, entity: EntityID, comptime T: type) ?*T {
                return self.components.getComponent(entity, T);
            }
            
            pub fn hasComponent(self: *Self, entity: EntityID, comptime T: type) bool {
                return self.components.hasComponent(entity, T);
            }
            
            pub fn removeComponent(self: *Self, entity: EntityID, comptime T: type) void {
                self.components.removeComponent(entity, T);
            }
            
            pub fn query(self: *Self, comptime query_types: []const type) !Query(query_types, ComponentMgr) {
                return self.components.createQuery(query_types);
            }
            
            pub fn getEntityCount(self: *const Self) u32 {
                return self.entities.getEntityCount();
            }
            
            // Rollback support
            pub fn copy(self: *const Self, allocator: std.mem.Allocator) !Self {
                return Self{
                    .entities = self.entities,
                    .components = try self.components.copy(allocator),
                    .deltaTime = self.deltaTime,
                    .time = self.time,
                    .frame_number = self.frame_number,
                    .input = self.input,
                };
            }
            
            pub fn restore(self: *Self, other: *const Self) void {
                self.entities = other.entities;
                self.components.restore(&other.components);
                self.deltaTime = other.deltaTime;
                self.time = other.time;
                self.frame_number = other.frame_number;
                self.input = other.input;
            }
        };
        
        // Return the compiled simulation type
        return struct {
            // Expose the Frame type for systems to use
            pub const Frame = FrameType;
            
            // Simulation state
            allocator: std.mem.Allocator,
            current_frame: FrameType,
            frame_history: ?std.ArrayList(FrameType) = null,
            
            const Self = @This();
            
            pub fn init(allocator: std.mem.Allocator) Self {
                var frame = FrameType{
                    .entities = EntityManager.init(),
                    .components = ComponentMgr.init(allocator),
                    .deltaTime = 0.0,
                    .time = 0.0,
                    .frame_number = 0,
                    .input = &[_]InputType{},
                };
                
                return Self{
                    .allocator = allocator,
                    .current_frame = frame,
                };
            }
            
            pub fn deinit(self: *Self) void {
                self.current_frame.components.deinit();
                if (self.frame_history) |*history| {
                    for (history.items) |*frame| {
                        frame.components.deinit();
                    }
                    history.deinit();
                }
            }
            
            // Initialize all systems
            pub fn initSystems(self: *Self, initial_time: f64) !void {
                self.current_frame.time = initial_time;
                self.current_frame.frame_number = 0;
                
                // Call each system's init - compile-time unrolled
                inline for (systems) |system| {
                    try system.init(&self.current_frame);
                }
            }
            
            // Update simulation - ECS controls execution
            pub fn update(self: *Self, input: []const InputType, deltaTime: f32, current_time: f64) void {
                self.current_frame.input = input;
                self.current_frame.deltaTime = deltaTime;
                self.current_frame.time = current_time;
                
                // Execute systems in order - compile-time unrolled for performance
                inline for (systems) |system| {
                    system.update(&self.current_frame);
                }
                
                self.current_frame.frame_number += 1;
            }
            
            // Get current frame for rendering
            pub fn getCurrentFrame(self: *Self) *FrameType {
                return &self.current_frame;
            }
            
            // Rollback support
            pub fn saveFrame(self: *Self) !FrameType {
                return try self.current_frame.copy(self.allocator);
            }
            
            pub fn restoreFrame(self: *Self, saved_frame: *const FrameType) void {
                self.current_frame.restore(saved_frame);
            }
        };
    }
};