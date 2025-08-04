const std = @import("std");

pub const EntityID = u32;
pub const INVALID_ENTITY: EntityID = 0;

pub const EntityManager = struct {
    next_entity_id: EntityID,
    entity_count: u32,
    
    pub fn init() EntityManager {
        return EntityManager{
            .next_entity_id = 1, // Start from 1 so 0 can be invalid
            .entity_count = 0,
        };
    }
    
    pub fn createEntity(self: *EntityManager) EntityID {
        const entity_id = self.next_entity_id;
        self.next_entity_id += 1;
        self.entity_count += 1;
        return entity_id;
    }
    
    pub fn destroyEntity(self: *EntityManager) void {
        if (self.entity_count > 0) {
            self.entity_count -= 1;
        }
    }
    
    pub fn getEntityCount(self: *const EntityManager) u32 {
        return self.entity_count;
    }
};