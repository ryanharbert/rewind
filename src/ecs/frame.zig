// Frame - Complete game state and primary ECS API
const std = @import("std");
const EntityManager = @import("entity.zig").EntityManager;
const ComponentManager = @import("component.zig").ComponentManager;
const Query = @import("query.zig").Query;
const EntityID = @import("entity.zig").EntityID;

// Frame contains all game state and provides the main ECS API
pub fn Frame(comptime component_types: []const type) type {
    const ComponentMgr = ComponentManager(component_types);
    
    return struct {
        const Self = @This();
        
        // All game state - copyable for rollback
        entities: EntityManager,
        components: ComponentMgr,
        
        // Frame context data - everything systems need
        deltaTime: f32,
        time: f64,
        frame_number: u64,
        input: []const @import("../gameplay-test-2/input.zig").InputCommand,
        
        // Frame is created/managed by Simulation - no allocator here
        pub fn init() Self {
            return Self{
                .entities = EntityManager.init(),
                .components = ComponentMgr.initEmpty(), // No allocator - managed by Simulation
                .deltaTime = 0.0,
                .time = 0.0,
                .frame_number = 0,
                .input = &[_]@import("../gameplay-test-2/input.zig").InputCommand{},
            };
        }
        
        // Primary ECS API - everything goes through Frame
        pub fn createEntity(self: *Self) EntityID {
            const entity_id = self.entities.createEntity();
            self.components.registerEntity(entity_id) catch {
                // Handle error - maybe return optional or error union
                return 0; // Invalid entity for now
            };
            return entity_id;
        }
        
        pub fn addComponent(self: *Self, entity: EntityID, component: anytype) void {
            self.components.addComponent(entity, component) catch {
                // Handle error
            };
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
        
        // Query system - main way to iterate entities
        pub fn query(self: *Self, comptime query_types: []const type) !Query(query_types, ComponentMgr) {
            // This needs allocator from Simulation level
            return self.components.createQuery(query_types);
        }
        
        pub fn getEntityCount(self: *const Self) u32 {
            return self.entities.getEntityCount();
        }
        
        // Copy frame state for rollback
        pub fn copy(self: *const Self, allocator: std.mem.Allocator) !Self {
            return Self{
                .entities = self.entities, // EntityManager is copyable
                .components = try self.components.copy(allocator),
                .deltaTime = self.deltaTime,
                .time = self.time,
                .frame_number = self.frame_number,
                .input = self.input, // Slice copy
            };
        }
        
        // Restore from another frame
        pub fn restore(self: *Self, other: *const Self) void {
            self.entities = other.entities;
            self.components.restore(&other.components);
            self.deltaTime = other.deltaTime;
            self.time = other.time;
            self.frame_number = other.frame_number;
            self.input = other.input;
        }
        
        // Cleanup - called by Simulation
        pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
            self.components.deinit(allocator);
        }
    };
}