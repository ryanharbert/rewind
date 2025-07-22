const std = @import("std");
const EntityID = @import("entity.zig").EntityID;

// Generic query system
pub fn Query(comptime component_types: []const type, comptime ComponentMgr: type) type {
    return struct {
        const Self = @This();
        
        component_manager: *ComponentMgr,
        entities: std.ArrayList(EntityID),
        current_index: usize,
        
        pub fn init(allocator: std.mem.Allocator, component_manager: *ComponentMgr) !Self {
            var entities = std.ArrayList(EntityID).init(allocator);
            
            // Get entities that match the query
            try component_manager.queryEntities(component_types, &entities);
            
            return Self{
                .component_manager = component_manager,
                .entities = entities,
                .current_index = 0,
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.entities.deinit();
        }
        
        pub fn next(self: *Self) ?EntityID {
            if (self.current_index >= self.entities.items.len) {
                return null;
            }
            
            const entity = self.entities.items[self.current_index];
            self.current_index += 1;
            return entity;
        }
        
        pub fn count(self: *const Self) usize {
            return self.entities.items.len;
        }
        
        pub fn reset(self: *Self) void {
            self.current_index = 0;
        }
    };
}