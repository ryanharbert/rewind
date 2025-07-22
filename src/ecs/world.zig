const std = @import("std");
const EntityManager = @import("entity.zig").EntityManager;
const EntityID = @import("entity.zig").EntityID;
const ComponentManager = @import("component.zig").ComponentManager;
const Query = @import("query.zig").Query;

// Generic ECS World that works with any component set
pub fn World(comptime component_types: []const type) type {
    const ComponentMgr = ComponentManager(component_types);
    
    return struct {
        const Self = @This();
        pub const ComponentManager = ComponentMgr;
        
        allocator: std.mem.Allocator,
        entities: EntityManager,
        components: ComponentMgr,
        
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .entities = EntityManager.init(),
                .components = ComponentMgr.init(allocator),
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.components.deinit();
        }
        
        pub fn createEntity(self: *Self) !EntityID {
            const entity_id = self.entities.createEntity();
            try self.components.component_masks.put(entity_id, 0);
            return entity_id;
        }
        
        pub fn destroyEntity(self: *Self, entity: EntityID) void {
            // Remove all components for this entity
            inline for (component_types) |T| {
                self.components.removeComponent(entity, T);
            }
            _ = self.components.component_masks.remove(entity);
            self.entities.destroyEntity();
        }
        
        pub fn addComponent(self: *Self, entity: EntityID, component: anytype) !void {
            try self.components.addComponent(entity, component);
        }
        
        pub fn hasComponent(self: *Self, entity: EntityID, comptime T: type) bool {
            return self.components.hasComponent(entity, T);
        }
        
        pub fn getComponent(self: *Self, entity: EntityID, comptime T: type) ?*T {
            return self.components.getComponent(entity, T);
        }
        
        pub fn removeComponent(self: *Self, entity: EntityID, comptime T: type) void {
            self.components.removeComponent(entity, T);
        }
        
        // Create a query for entities with specific components
        pub fn query(self: *Self, comptime query_types: []const type) !Query(query_types, ComponentMgr) {
            return try Query(query_types, ComponentMgr).init(self.allocator, &self.components);
        }
        
        pub fn getEntityCount(self: *const Self) u32 {
            return self.entities.getEntityCount();
        }
    };
}

// Helper to validate component types at compile time
pub fn validateComponents(comptime component_types: []const type) void {
    comptime {
        if (component_types.len == 0) {
            @compileError("Must register at least one component type");
        }
        
        // Check for duplicate types
        for (component_types, 0..) |T1, i| {
            for (component_types[i + 1 ..]) |T2| {
                if (T1 == T2) {
                    @compileError("Duplicate component type: " ++ @typeName(T1));
                }
            }
        }
        
        // Ensure all types are structs (optional validation)
        for (component_types) |T| {
            if (@typeInfo(T) != .Struct) {
                @compileError("Component must be a struct type: " ++ @typeName(T));
            }
        }
    }
}