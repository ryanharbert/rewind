const std = @import("std");

// Fixed-point precision: 16.16 format (65536 = 1.0)
pub const FIXED_SCALE: i32 = 65536;
pub const FIXED_SHIFT: u5 = 16;

// Convert float to fixed-point
pub fn toFixed(value: f32) i32 {
    return @intFromFloat(value * @as(f32, @floatFromInt(FIXED_SCALE)));
}

// Convert fixed-point to float
pub fn fixedToFloat(value: i32) f32 {
    return @as(f32, @floatFromInt(value)) / @as(f32, @floatFromInt(FIXED_SCALE));
}

// Vec2 - Fixed-point 2D vector (deterministic)
pub const Vec2 = struct {
    x: i32,
    y: i32,

    pub fn init(x: f32, y: f32) Vec2 {
        return Vec2{
            .x = toFixed(x),
            .y = toFixed(y),
        };
    }

    pub fn initFixed(x: i32, y: i32) Vec2 {
        return Vec2{ .x = x, .y = y };
    }

    pub fn add(self: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn sub(self: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn mul(self: Vec2, scalar: f32) Vec2 {
        const fixed_scalar = toFixed(scalar);
        return Vec2{
            .x = @intCast(((@as(i64, self.x) * @as(i64, fixed_scalar)) >> FIXED_SHIFT)),
            .y = @intCast(((@as(i64, self.y) * @as(i64, fixed_scalar)) >> FIXED_SHIFT)),
        };
    }

    pub fn dot(self: Vec2, other: Vec2) i32 {
        const x_prod = (@as(i64, self.x) * @as(i64, other.x)) >> FIXED_SHIFT;
        const y_prod = (@as(i64, self.y) * @as(i64, other.y)) >> FIXED_SHIFT;
        return @intCast(x_prod + y_prod);
    }

    pub fn lengthSq(self: Vec2) i32 {
        return self.dot(self);
    }

    pub fn toFloat(self: Vec2) Vec2f {
        return Vec2f{
            .x = fixedToFloat(self.x),
            .y = fixedToFloat(self.y),
        };
    }

    pub fn toFloatX(self: Vec2) f32 {
        return fixedToFloat(self.x);
    }

    pub fn toFloatY(self: Vec2) f32 {
        return fixedToFloat(self.y);
    }
};

// Vec2f - Float 2D vector (for rendering)
pub const Vec2f = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vec2f {
        return Vec2f{ .x = x, .y = y };
    }

    pub fn add(self: Vec2f, other: Vec2f) Vec2f {
        return Vec2f{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn sub(self: Vec2f, other: Vec2f) Vec2f {
        return Vec2f{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn mul(self: Vec2f, scalar: f32) Vec2f {
        return Vec2f{ .x = self.x * scalar, .y = self.y * scalar };
    }

    pub fn dot(self: Vec2f, other: Vec2f) f32 {
        return self.x * other.x + self.y * other.y;
    }

    pub fn lengthSq(self: Vec2f) f32 {
        return self.dot(self);
    }

    pub fn length(self: Vec2f) f32 {
        return std.math.sqrt(self.lengthSq());
    }

    pub fn normalize(self: Vec2f) Vec2f {
        const len = self.length();
        if (len == 0.0) return Vec2f.init(0.0, 0.0);
        return Vec2f{ .x = self.x / len, .y = self.y / len };
    }
};

// Math utility functions
pub const mathf = struct {
    pub fn lerp(a: f32, b: f32, t: f32) f32 {
        return a + (b - a) * t;
    }

    pub fn clamp(value: f32, min_val: f32, max_val: f32) f32 {
        return std.math.clamp(value, min_val, max_val);
    }

    pub fn clampFixed(value: i32, min_val: i32, max_val: i32) i32 {
        return std.math.clamp(value, min_val, max_val);
    }

    pub fn smoothstep(edge0: f32, edge1: f32, x: f32) f32 {
        const t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
        return t * t * (3.0 - 2.0 * t);
    }

    pub fn approach(current: f32, target: f32, delta: f32) f32 {
        const diff = target - current;
        if (@abs(diff) <= delta) {
            return target;
        }
        return current + std.math.sign(diff) * delta;
    }
};