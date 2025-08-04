// Tank game input commands
pub const InputCommand = union(enum) {
    rotate_left: struct { strength: f32 },
    rotate_right: struct { strength: f32 },
    move_forward: struct { strength: f32 },
    move_backward: struct { strength: f32 },
    
    pub fn rotateLeft(strength: f32) InputCommand {
        return InputCommand{ .rotate_left = .{ .strength = strength } };
    }
    
    pub fn rotateRight(strength: f32) InputCommand {
        return InputCommand{ .rotate_right = .{ .strength = strength } };
    }
    
    pub fn moveForward(strength: f32) InputCommand {
        return InputCommand{ .move_forward = .{ .strength = strength } };
    }
    
    pub fn moveBackward(strength: f32) InputCommand {
        return InputCommand{ .move_backward = .{ .strength = strength } };
    }
};