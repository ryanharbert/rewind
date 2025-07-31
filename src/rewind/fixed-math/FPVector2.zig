const std = @import("std");
const FP = @import("FP.zig").FP;
const fp = @import("FP.zig").fp;

/// A 2D vector using fixed-point arithmetic for deterministic calculations
pub const FPVector2 = struct {
    x: FP,
    y: FP,

    /// Static constants
    pub const ZERO = FPVector2{ .x = fp(0), .y = fp(0) };
    pub const ONE = FPVector2{ .x = fp(1), .y = fp(1) };
    pub const RIGHT = FPVector2{ .x = fp(1), .y = fp(0) };
    pub const LEFT = FPVector2{ .x = fp(-1), .y = fp(0) };
    pub const UP = FPVector2{ .x = fp(0), .y = fp(1) };
    pub const DOWN = FPVector2{ .x = fp(0), .y = fp(-1) };

    pub const MIN_VALUE = FPVector2{ .x = FP.MIN_VALUE, .y = FP.MIN_VALUE };
    pub const MAX_VALUE = FPVector2{ .x = FP.MAX_VALUE, .y = FP.MAX_VALUE };
    pub const USEABLE_MIN = FPVector2{ .x = FP.USEABLE_MIN, .y = FP.USEABLE_MIN };
    pub const USEABLE_MAX = FPVector2{ .x = FP.USEABLE_MAX, .y = FP.USEABLE_MAX };

    /// Create a new FPVector2
    pub inline fn new(x: FP, y: FP) FPVector2 {
        return FPVector2{ .x = x, .y = y };
    }

    /// Create FPVector2 from integers
    pub inline fn fromInt(x: anytype, y: anytype) FPVector2 {
        return FPVector2{ .x = FP.fromInt(x), .y = FP.fromInt(y) };
    }

    /// Create FPVector2 from compile-time floats
    pub inline fn fromFloat(comptime x: f64, comptime y: f64) FPVector2 {
        comptime {
            return FPVector2{ .x = FP.fromFloat(x), .y = FP.fromFloat(y) };
        }
    }

    /// UNSAFE: Create FPVector2 from runtime floats (breaks determinism!)
    pub inline fn fromFloatUnsafe(x: f64, y: f64) FPVector2 {
        return FPVector2{ .x = FP.fromFloatUnsafe(x), .y = FP.fromFloatUnsafe(y) };
    }

    /// Arithmetic operations

    /// Add two vectors
    pub inline fn add(self: FPVector2, other: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.add(other.x),
            .y = self.y.add(other.y),
        };
    }

    /// Subtract other from self
    pub inline fn sub(self: FPVector2, other: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.sub(other.x),
            .y = self.y.sub(other.y),
        };
    }

    /// Multiply vector by scalar
    pub inline fn mul(self: FPVector2, scalar: FP) FPVector2 {
        return FPVector2{
            .x = self.x.mul(scalar),
            .y = self.y.mul(scalar),
        };
    }

    /// Multiply vector by integer
    pub inline fn mulInt(self: FPVector2, scalar: i32) FPVector2 {
        return FPVector2{
            .x = FP{ .raw_value = self.x.raw_value * scalar },
            .y = FP{ .raw_value = self.y.raw_value * scalar },
        };
    }

    /// Divide vector by scalar
    pub inline fn div(self: FPVector2, scalar: FP) FPVector2 {
        return FPVector2{
            .x = self.x.div(scalar),
            .y = self.y.div(scalar),
        };
    }

    /// Divide vector by integer
    pub inline fn divInt(self: FPVector2, scalar: i32) FPVector2 {
        return FPVector2{
            .x = FP{ .raw_value = @divTrunc(self.x.raw_value, scalar) },
            .y = FP{ .raw_value = @divTrunc(self.y.raw_value, scalar) },
        };
    }

    /// Negate vector
    pub inline fn negate(self: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.negate(),
            .y = self.y.negate(),
        };
    }

    /// Vector operations

    /// Dot product
    pub inline fn dot(self: FPVector2, other: FPVector2) FP {
        return self.x.mul(other.x).add(self.y.mul(other.y));
    }

    /// Cross product (2D perp-dot product)
    pub inline fn cross(self: FPVector2, other: FPVector2) FP {
        return self.x.mul(other.y).sub(self.y.mul(other.x));
    }

    /// Get squared magnitude (faster than magnitude)
    pub inline fn sqrMagnitude(self: FPVector2) FP {
        return self.x.square().add(self.y.square());
    }

    /// Get magnitude
    pub inline fn magnitude(self: FPVector2) FP {
        return self.sqrMagnitude().sqrt();
    }

    /// Get fast magnitude approximation
    pub inline fn magnitudeFast(self: FPVector2) FP {
        return self.sqrMagnitude().sqrtFast();
    }

    /// Normalize vector
    pub fn normalize(self: FPVector2) FPVector2 {
        const mag_sqr = self.sqrMagnitude();
        if (mag_sqr.raw_value == 0) return FPVector2.ZERO;
        
        const mag = mag_sqr.sqrt();
        return self.div(mag);
    }

    /// Normalize vector with magnitude output
    pub fn normalizeWithMagnitude(self: FPVector2, out_magnitude: *FP) FPVector2 {
        const mag_sqr = self.sqrMagnitude();
        if (mag_sqr.raw_value == 0) {
            out_magnitude.* = fp(0);
            return FPVector2.ZERO;
        }
        
        const mag = mag_sqr.sqrt();
        out_magnitude.* = mag;
        return self.div(mag);
    }

    /// Fast normalize using reciprocal square root
    pub fn normalizeFast(self: FPVector2) FPVector2 {
        const mag_sqr = self.sqrMagnitude();
        if (mag_sqr.raw_value == 0) return FPVector2.ZERO;
        
        const inv_mag = mag_sqr.rsqrtFast();
        return self.mul(inv_mag);
    }

    /// Get normalized vector (property-like)
    pub inline fn normalized(self: FPVector2) FPVector2 {
        return self.normalize();
    }

    /// Distance and comparison

    /// Distance between two vectors
    pub inline fn distance(a: FPVector2, b: FPVector2) FP {
        return a.sub(b).magnitude();
    }

    /// Squared distance between two vectors (faster)
    pub inline fn distanceSquared(a: FPVector2, b: FPVector2) FP {
        return a.sub(b).sqrMagnitude();
    }

    /// Fast distance approximation
    pub inline fn distanceFast(a: FPVector2, b: FPVector2) FP {
        return a.sub(b).magnitudeFast();
    }

    /// Equality comparison
    pub inline fn eq(self: FPVector2, other: FPVector2) bool {
        return self.x.eq(other.x) and self.y.eq(other.y);
    }

    /// Inequality comparison
    pub inline fn neq(self: FPVector2, other: FPVector2) bool {
        return !self.eq(other);
    }

    /// Approximately equal (within epsilon)
    pub inline fn approxEq(self: FPVector2, other: FPVector2, epsilon: FP) bool {
        const diff = self.sub(other);
        return diff.x.abs().lte(epsilon) and diff.y.abs().lte(epsilon);
    }

    /// Component operations

    /// Get minimum components
    pub inline fn min(a: FPVector2, b: FPVector2) FPVector2 {
        return FPVector2{
            .x = a.x.min(b.x),
            .y = a.y.min(b.y),
        };
    }

    /// Get maximum components
    pub inline fn max(a: FPVector2, b: FPVector2) FPVector2 {
        return FPVector2{
            .x = a.x.max(b.x),
            .y = a.y.max(b.y),
        };
    }

    /// Clamp components between min and max
    pub inline fn clamp(self: FPVector2, min_val: FPVector2, max_val: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.clamp(min_val.x, max_val.x),
            .y = self.y.clamp(min_val.y, max_val.y),
        };
    }

    /// Clamp magnitude to max length
    pub fn clampMagnitude(self: FPVector2, max_length: FP) FPVector2 {
        const mag_sqr = self.sqrMagnitude();
        const max_length_sqr = max_length.square();
        
        if (mag_sqr.lte(max_length_sqr)) {
            return self;
        }
        
        const mag = mag_sqr.sqrt();
        return self.div(mag).mul(max_length);
    }

    /// Scale (component-wise multiplication)
    pub inline fn scale(self: FPVector2, scale_vec: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.mul(scale_vec.x),
            .y = self.y.mul(scale_vec.y),
        };
    }

    /// Absolute value of components
    pub inline fn abs(self: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.abs(),
            .y = self.y.abs(),
        };
    }

    /// Sign of components
    pub inline fn sign(self: FPVector2) FPVector2 {
        return FPVector2{
            .x = self.x.sign(),
            .y = self.y.sign(),
        };
    }

    /// Rotation and angles

    /// Rotate vector by angle in radians (counter-clockwise)
    pub fn rotate(self: FPVector2, radians: FP) FPVector2 {
        const cos_val = radians.cos();
        const sin_val = radians.sin();
        
        return FPVector2{
            .x = self.x.mul(cos_val).sub(self.y.mul(sin_val)),
            .y = self.x.mul(sin_val).add(self.y.mul(cos_val)),
        };
    }

    /// Rotate vector using precomputed sin/cos values
    pub fn rotateWithSinCos(self: FPVector2, sin_val: FP, cos_val: FP) FPVector2 {
        return FPVector2{
            .x = self.x.mul(cos_val).sub(self.y.mul(sin_val)),
            .y = self.x.mul(sin_val).add(self.y.mul(cos_val)),
        };
    }

    /// Rotate 90 degrees clockwise
    pub inline fn rotateRight(self: FPVector2) FPVector2 {
        return FPVector2{ .x = self.y, .y = self.x.negate() };
    }

    /// Rotate 90 degrees counter-clockwise
    pub inline fn rotateLeft(self: FPVector2) FPVector2 {
        return FPVector2{ .x = self.y.negate(), .y = self.x };
    }

    /// Get angle between two vectors in radians
    pub fn angle(a: FPVector2, b: FPVector2) FP {
        const a_norm = a.normalize();
        const b_norm = b.normalize();
        const dot_val = a_norm.dot(b_norm).clamp(fp(-1), fp(1));
        return dot_val.acos();
    }

    /// Get signed angle between two vectors in radians
    pub fn signedAngle(a: FPVector2, b: FPVector2) FP {
        const angle_val = angle(a, b);
        const cross_val = a.cross(b);
        return if (cross_val.raw_value >= 0) angle_val else angle_val.negate();
    }

    /// Get angle from positive X axis (atan2)
    pub inline fn angleFromX(self: FPVector2) FP {
        return FP.atan2(self.y, self.x);
    }

    /// Create vector from angle
    pub inline fn fromAngle(radians: FP) FPVector2 {
        return FPVector2{
            .x = radians.cos(),
            .y = radians.sin(),
        };
    }

    /// Interpolation

    /// Linear interpolation
    pub inline fn lerp(start: FPVector2, end: FPVector2, t: FP) FPVector2 {
        const clamped_t = t.clamp01();
        return FPVector2{
            .x = start.x.lerp(end.x, clamped_t),
            .y = start.y.lerp(end.y, clamped_t),
        };
    }

    /// Linear interpolation unclamped
    pub inline fn lerpUnclamped(start: FPVector2, end: FPVector2, t: FP) FPVector2 {
        return FPVector2{
            .x = start.x.lerpUnclamped(end.x, t),
            .y = start.y.lerpUnclamped(end.y, t),
        };
    }

    /// Move towards target
    pub inline fn moveTowards(current: FPVector2, target: FPVector2, max_distance: FP) FPVector2 {
        const diff = target.sub(current);
        const dist_sqr = diff.sqrMagnitude();
        
        if (dist_sqr.lte(max_distance.square())) {
            return target;
        }
        
        const direction = diff.normalize();
        return current.add(direction.mul(max_distance));
    }

    /// Smooth damp
    pub fn smoothDamp(current: FPVector2, target: FPVector2, velocity: *FPVector2, smooth_time: FP, max_speed: FP, delta_time: FP) FPVector2 {
        var new_velocity_x = velocity.x;
        var new_velocity_y = velocity.y;
        
        const x = current.x.smoothDamp(target.x, &new_velocity_x, smooth_time, max_speed, delta_time);
        const y = current.y.smoothDamp(target.y, &new_velocity_y, smooth_time, max_speed, delta_time);
        
        velocity.x = new_velocity_x;
        velocity.y = new_velocity_y;
        
        return FPVector2{ .x = x, .y = y };
    }

    /// Smooth step interpolation
    pub inline fn smoothStep(edge0: FPVector2, edge1: FPVector2, x: FPVector2) FPVector2 {
        return FPVector2{
            .x = FP.smoothstep(edge0.x, edge1.x, x.x),
            .y = FP.smoothstep(edge0.y, edge1.y, x.y),
        };
    }

    /// Reflection and projection

    /// Reflect vector off surface with normal
    pub fn reflect(self: FPVector2, normal: FPVector2) FPVector2 {
        const dot2 = self.dot(normal).mul(fp(2));
        return self.sub(normal.mul(dot2));
    }

    /// Project vector onto another vector
    pub fn project(self: FPVector2, onto: FPVector2) FPVector2 {
        const onto_mag_sqr = onto.sqrMagnitude();
        if (onto_mag_sqr.raw_value == 0) return FPVector2.ZERO;
        
        const dot_val = self.dot(onto);
        return onto.mul(dot_val.div(onto_mag_sqr));
    }

    /// Project vector onto normalized vector (faster)
    pub fn projectOntoNormalized(self: FPVector2, onto_normalized: FPVector2) FPVector2 {
        const dot_val = self.dot(onto_normalized);
        return onto_normalized.mul(dot_val);
    }

    /// Get perpendicular component
    pub fn perpendicular(self: FPVector2, direction: FPVector2) FPVector2 {
        return self.sub(self.project(direction));
    }

    /// Conversion to 3D vectors

    /// Convert to 3D vector (x, 0, y)
    pub inline fn toXOY(self: FPVector2) struct { x: FP, y: FP, z: FP } {
        return .{ .x = self.x, .y = fp(0), .z = self.y };
    }

    /// Convert to 3D vector (x, y, 0)
    pub inline fn toXYO(self: FPVector2) struct { x: FP, y: FP, z: FP } {
        return .{ .x = self.x, .y = self.y, .z = fp(0) };
    }

    /// Convert to 3D vector (0, x, y)
    pub inline fn toOXY(self: FPVector2) struct { x: FP, y: FP, z: FP } {
        return .{ .x = fp(0), .y = self.x, .z = self.y };
    }

    /// Swizzle operations

    pub inline fn xx(self: FPVector2) FPVector2 {
        return FPVector2{ .x = self.x, .y = self.x };
    }

    pub inline fn yy(self: FPVector2) FPVector2 {
        return FPVector2{ .x = self.y, .y = self.y };
    }

    pub inline fn yx(self: FPVector2) FPVector2 {
        return FPVector2{ .x = self.y, .y = self.x };
    }

    /// Advanced operations

    /// Hermite interpolation
    pub fn hermite(p0: FPVector2, p1: FPVector2, m0: FPVector2, m1: FPVector2, t: FP) FPVector2 {
        return FPVector2{
            .x = FP.hermite(p0.x, p1.x, m0.x, m1.x, t),
            .y = FP.hermite(p0.y, p1.y, m0.y, m1.y, t),
        };
    }

    /// Catmull-Rom spline interpolation
    pub fn catmullRom(p0: FPVector2, p1: FPVector2, p2: FPVector2, p3: FPVector2, t: FP) FPVector2 {
        return FPVector2{
            .x = FP.catmullRom(p0.x, p1.x, p2.x, p3.x, t),
            .y = FP.catmullRom(p0.y, p1.y, p2.y, p3.y, t),
        };
    }

    /// Barycentric interpolation
    pub fn barycentric(v1: FPVector2, v2: FPVector2, v3: FPVector2, t1: FP, t2: FP) FPVector2 {
        const t3 = fp(1).sub(t1).sub(t2);
        return FPVector2{
            .x = FP.barycentric(v1.x, v2.x, v3.x, t1, t2, t3),
            .y = FP.barycentric(v1.y, v2.y, v3.y, t1, t2, t3),
        };
    }

    /// String formatting
    pub fn format(
        self: FPVector2,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("({}, {})", .{ self.x, self.y });
    }
};

/// Convenience function for creating FPVector2 deterministically at compile time
/// Works with compile-time integers and floats
pub inline fn fpVec2(x: anytype, y: anytype) FPVector2 {
    const TX = @TypeOf(x);
    const TY = @TypeOf(y);
    const info_x = @typeInfo(TX);
    const info_y = @typeInfo(TY);
    
    const x_fp = switch (info_x) {
        .comptime_int => FP.fromInt(x),
        .comptime_float => FP.fromFloat(x),
        else => @compileError("fpVec2() only accepts compile-time integers or floats. Use FPVector2.fromFloatUnsafe() for runtime floats (breaks determinism!)"),
    };
    
    const y_fp = switch (info_y) {
        .comptime_int => FP.fromInt(y),
        .comptime_float => FP.fromFloat(y),
        else => @compileError("fpVec2() only accepts compile-time integers or floats. Use FPVector2.fromFloatUnsafe() for runtime floats (breaks determinism!)"),
    };
    
    return FPVector2{ .x = x_fp, .y = y_fp };
}