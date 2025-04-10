const std = @import("std");
const Allocator = std.mem.Allocator;

pub const EntityId = u32;
pub const ComponentId = u32;

pub const World = struct {
    allocator: Allocator,
    entities: std.ArrayList(EntityId),
    next_entity_id: EntityId,
    components: std.AutoHashMap(EntityId, std.ArrayList(ComponentId)),

    pub fn init(allocator: Allocator) World {
        return World{
            .allocator = allocator,
            .entities = std.ArrayList(EntityId).init(allocator),
            .next_entity_id = 0,
            .components = std.AutoHashMap(EntityId, std.ArrayList(ComponentId)).init(allocator),
        };
    }

    pub fn deinit(self: *World) void {
        var it = self.components.valueIterator();
        while (it.next()) |component_list| {
            component_list.deinit();
        }
        self.components.deinit();
        self.entities.deinit();
    }

    pub fn createEntity(self: *World) !EntityId {
        const entity_id = self.next_entity_id;
        self.next_entity_id += 1;
        try self.entities.append(entity_id);
        try self.components.put(entity_id, std.ArrayList(ComponentId).init(self.allocator));
        return entity_id;
    }

    pub fn destroyEntity(self: *World, entity_id: EntityId) void {
        if (self.components.getPtr(entity_id)) |component_list| {
            component_list.deinit();
            _ = self.components.remove(entity_id);
        }
        // Remove from entities list
        for (self.entities.items, 0..) |id, i| {
            if (id == entity_id) {
                _ = self.entities.orderedRemove(i);
                break;
            }
        }
    }

    pub fn addComponent(self: *World, entity_id: EntityId, component_id: ComponentId) !void {
        if (self.components.getPtr(entity_id)) |component_list| {
            try component_list.append(component_id);
        }
    }

    pub fn removeComponent(self: *World, entity_id: EntityId, component_id: ComponentId) void {
        if (self.components.getPtr(entity_id)) |component_list| {
            for (component_list.items, 0..) |id, i| {
                if (id == component_id) {
                    _ = component_list.orderedRemove(i);
                    break;
                }
            }
        }
    }
}; 