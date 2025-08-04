const math = @import("math.zig");

pub const Transform = struct {
    position: math.Vec2,
    rotation: f32, // in radians
    scale: math.Vec2,

    pub fn init(x: f32, y: f32) Transform {
        return Transform{
            .position = math.Vec2.init(x, y),
            .rotation = 0.0,
            .scale = math.Vec2.init(1.0, 1.0),
        };
    }

    pub fn setPosition(self: *Transform, x: f32, y: f32) void {
        self.position = math.Vec2.init(x, y);
    }

    pub fn setRotation(self: *Transform, radians: f32) void {
        self.rotation = radians;
    }

    pub fn setScale(self: *Transform, x: f32, y: f32) void {
        self.scale = math.Vec2.init(x, y);
    }

    pub fn translate(self: *Transform, dx: f32, dy: f32) void {
        self.position = self.position.add(math.Vec2.init(dx, dy));
    }

    pub fn rotate(self: *Transform, radians: f32) void {
        self.rotation += radians;
    }
};