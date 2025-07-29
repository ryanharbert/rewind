const std = @import("std");

/// A fixed-point number with 16 bits for the fractional part and 48 bits for the integral part.
/// This provides deterministic arithmetic operations for rollback networking and physics simulations.
pub const FP = struct {
    /// The raw 64-bit value of the fixed-point number
    raw_value: i64,

    /// Constants
    pub const PRECISION: u6 = 16;
    pub const FRACTIONAL_MASK: i64 = (1 << PRECISION) - 1;
    pub const INTEGER_MASK: i64 = ~FRACTIONAL_MASK;
    pub const ONE_RAW: i64 = 1 << PRECISION;
    pub const HALF_RAW: i64 = 1 << (PRECISION - 1);

    /// Create FP from raw value
    pub inline fn fromRaw(value: i64) FP {
        return FP{ .raw_value = value };
    }

    /// Create FP from integer
    pub inline fn fromInt(value: anytype) FP {
        const T = @TypeOf(value);
        comptime {
            const type_info = @typeInfo(T);
            if (type_info != .int and type_info != .comptime_int) {
                @compileError("fromInt expects an integer type");
            }
        }
        return FP{ .raw_value = @as(i64, value) << PRECISION };
    }

    /// Create FP from compile-time known float (ONLY for comptime constants)
    /// This function can ONLY be called at compile time to ensure determinism
    pub inline fn fromFloat(comptime value: f64) FP {
        comptime {
            return FP{ .raw_value = @as(i64, @intFromFloat(value * @as(f64, ONE_RAW))) };
        }
    }

    /// UNSAFE: Create FP from runtime float value
    /// WARNING: This breaks determinism! Only use for:
    /// - Loading data from external sources
    /// - Debug display
    /// - One-time initialization from config files
    /// NEVER use in gameplay/simulation code!
    pub inline fn fromFloatUnsafe(value: f64) FP {
        return FP{ .raw_value = @as(i64, @intFromFloat(value * @as(f64, ONE_RAW))) };
    }

    /// UNSAFE: Create FP from runtime float with rounding
    /// WARNING: This breaks determinism! See fromFloatUnsafe for usage warnings.
    pub inline fn fromFloatRoundedUnsafe(value: f64) FP {
        return FP{ .raw_value = @as(i64, @intFromFloat(@round(value * @as(f64, ONE_RAW)))) };
    }

    /// Convert to integer (truncating fractional part)
    pub inline fn toInt(self: FP, comptime T: type) T {
        return @intCast(self.raw_value >> PRECISION);
    }

    /// Convert to float (for debugging/display only, not for calculations)
    pub inline fn toFloat(self: FP, comptime T: type) T {
        return @as(T, @floatFromInt(self.raw_value)) / @as(T, @floatFromInt(ONE_RAW));
    }

    /// Get integer part as i64
    pub inline fn asLong(self: FP) i64 {
        return self.raw_value >> PRECISION;
    }

    /// Get integer part as i32
    pub inline fn asInt(self: FP) i32 {
        return @intCast(self.raw_value >> PRECISION);
    }

    /// Arithmetic operations
    
    /// Addition: returns a + b
    pub inline fn add(a: FP, b: FP) FP {
        return FP{ .raw_value = a.raw_value + b.raw_value };
    }

    /// Subtraction: returns a - b
    pub inline fn sub(a: FP, b: FP) FP {
        return FP{ .raw_value = a.raw_value - b.raw_value };
    }

    /// Multiplication: returns a * b (with rounding for precision)
    pub inline fn mul(a: FP, b: FP) FP {
        // Fast multiplication with rounding
        return FP{ .raw_value = (a.raw_value * b.raw_value + HALF_RAW) >> PRECISION };
    }

    /// Multiplication without rounding: returns a * b (truncated)
    pub inline fn mulTruncate(a: FP, b: FP) FP {
        // Multiplication without rounding
        return FP{ .raw_value = (a.raw_value * b.raw_value) >> PRECISION };
    }

    /// Division: returns a / b
    pub inline fn div(a: FP, b: FP) FP {
        return FP{ .raw_value = @divTrunc(a.raw_value << PRECISION, b.raw_value) };
    }

    /// Modulo: returns a % b
    pub inline fn mod(a: FP, b: FP) FP {
        return FP{ .raw_value = @mod(a.raw_value, b.raw_value) };
    }

    /// Negation: returns -self
    pub inline fn negate(self: FP) FP {
        return FP{ .raw_value = -self.raw_value };
    }

    /// Comparison operations
    
    /// Equality test: returns true if a == b
    pub inline fn eq(a: FP, b: FP) bool {
        return a.raw_value == b.raw_value;
    }

    /// Inequality test: returns true if a != b
    pub inline fn neq(a: FP, b: FP) bool {
        return a.raw_value != b.raw_value;
    }

    /// Less than test: returns true if a < b
    pub inline fn lt(a: FP, b: FP) bool {
        return a.raw_value < b.raw_value;
    }

    /// Less than or equal test: returns true if a <= b
    pub inline fn lte(a: FP, b: FP) bool {
        return a.raw_value <= b.raw_value;
    }

    /// Greater than test: returns true if a > b
    pub inline fn gt(a: FP, b: FP) bool {
        return a.raw_value > b.raw_value;
    }

    /// Greater than or equal test: returns true if a >= b
    pub inline fn gte(a: FP, b: FP) bool {
        return a.raw_value >= b.raw_value;
    }

    /// Compare function for sorting
    pub fn compare(a: FP, b: FP) std.math.Order {
        if (a.raw_value < b.raw_value) return .lt;
        if (a.raw_value > b.raw_value) return .gt;
        return .eq;
    }

    /// Math operations
    
    /// Returns the sign of the value (1 for positive/zero, -1 for negative)
    pub inline fn sign(self: FP) FP {
        return if (self.raw_value >= 0) fp(1) else fp(-1);
    }

    /// Returns the sign with zero handling (1, 0, or -1)
    pub inline fn signZero(self: FP) FP {
        if (self.raw_value < 0) return fp(-1);
        if (self.raw_value > 0) return fp(1);
        return fp(0);
    }

    /// Returns the absolute value
    pub inline fn abs(self: FP) FP {
        const mask = self.raw_value >> 63;
        return FP{ .raw_value = (self.raw_value + mask) ^ mask };
    }

    /// Returns the larger of two values
    pub inline fn max(a: FP, b: FP) FP {
        return if (a.raw_value >= b.raw_value) a else b;
    }

    /// Returns the smaller of two values
    pub inline fn min(a: FP, b: FP) FP {
        return if (a.raw_value <= b.raw_value) a else b;
    }

    /// Clamps a value between min and max
    pub inline fn clamp(self: FP, min_val: FP, max_val: FP) FP {
        if (self.raw_value < min_val.raw_value) return min_val;
        if (self.raw_value > max_val.raw_value) return max_val;
        return self;
    }

    /// Clamps a value between 0 and 1
    pub inline fn clamp01(self: FP) FP {
        if (self.raw_value < 0) return fp(0);
        if (self.raw_value > ONE_RAW) return fp(1);
        return self;
    }

    /// Returns the largest integer less than or equal to the value
    pub inline fn floor(self: FP) FP {
        return FP{ .raw_value = self.raw_value & INTEGER_MASK };
    }

    /// Returns the largest integer less than or equal to the value as an integer
    pub inline fn floorToInt(self: FP) i32 {
        return @intCast(self.raw_value >> PRECISION);
    }

    /// Returns the smallest integer greater than or equal to the value
    pub inline fn ceil(self: FP) FP {
        if ((self.raw_value & FRACTIONAL_MASK) != 0) {
            return FP{ .raw_value = (self.raw_value & INTEGER_MASK) + ONE_RAW };
        }
        return self;
    }

    /// Returns the smallest integer greater than or equal to the value as an integer
    pub inline fn ceilToInt(self: FP) i32 {
        if ((self.raw_value & FRACTIONAL_MASK) != 0) {
            return @intCast((self.raw_value >> PRECISION) + 1);
        }
        return @intCast(self.raw_value >> PRECISION);
    }

    /// Rounds to the nearest integer
    pub inline fn round(self: FP) FP {
        const fractional = self.raw_value & FRACTIONAL_MASK;
        var result = self.floor();
        
        if (fractional < HALF_RAW) {
            return result;
        } else if (fractional > HALF_RAW) {
            return result.add(fp(1));
        } else {
            // Round to even (banker's rounding)
            if ((result.raw_value & ONE_RAW) != 0) {
                return result.add(fp(1));
            }
            return result;
        }
    }

    /// Rounds to the nearest integer as an integer
    pub inline fn roundToInt(self: FP) i32 {
        const fractional = self.raw_value & FRACTIONAL_MASK;
        const base: i32 = @intCast(self.raw_value >> PRECISION);
        
        if (fractional < HALF_RAW) {
            return base;
        } else if (fractional > HALF_RAW) {
            return base + 1;
        } else {
            // Round to even (banker's rounding)
            if ((base & 1) != 0) {
                return base + 1;
            }
            return base;
        }
    }

    /// Returns only the fractional part
    pub inline fn fraction(self: FP) FP {
        return FP{ .raw_value = self.raw_value & FRACTIONAL_MASK };
    }

    /// Linear interpolation between two values
    pub inline fn lerp(start: FP, end: FP, t: FP) FP {
        const clamped_t = t.clamp01();
        const diff = end.sub(start);
        return start.add(diff.mul(clamped_t));
    }

    /// Linear interpolation without clamping t
    pub inline fn lerpUnclamped(start: FP, end: FP, t: FP) FP {
        const diff = end.sub(start);
        return start.add(diff.mul(t));
    }

    /// Square root approximation using Newton-Raphson
    pub fn sqrt(self: FP) FP {
        if (self.raw_value < 0) {
            std.debug.panic("Cannot take square root of negative number", .{});
        }
        if (self.raw_value == 0) return fp(0);
        
        // Initial guess using bit manipulation
        const lz = @clz(self.raw_value);
        const shift = (64 - lz - PRECISION) / 2;
        var x = FP{ .raw_value = @as(i64, 1) << @intCast(PRECISION + shift) };
        
        // Newton-Raphson iterations
        var i: u32 = 0;
        while (i < 8) : (i += 1) {
            const div_result = self.div(x);
            const sum = x.add(div_result);
            x = sum.div(fp(2));
        }
        
        return x;
    }

    /// Fast square root approximation using bit manipulation and 2 Newton-Raphson iterations
    /// About 3-4x faster than full sqrt() but less accurate
    /// Use when you need actual distance but want speed over precision
    pub fn sqrtFast(self: FP) FP {
        if (self.raw_value < 0) {
            std.debug.panic("Cannot take square root of negative number", .{});
        }
        if (self.raw_value == 0) return fp(0);
        
        // Initial guess using bit manipulation (same as regular sqrt)
        const lz = @clz(self.raw_value);
        const shift = (64 - lz - PRECISION) / 2;
        var x = FP{ .raw_value = @as(i64, 1) << @intCast(PRECISION + shift) };
        
        // Only 1-2 Newton-Raphson iterations for speed
        const div_result = self.div(x);
        const sum = x.add(div_result);
        x = sum.div(fp(2));
        
        // Optional second iteration for slightly better accuracy
        const div_result2 = self.div(x);
        const sum2 = x.add(div_result2);
        x = sum2.div(fp(2));
        
        return x;
    }

    /// Reciprocal square root (1/sqrt(x)) using fast sqrt approximation
    /// Essential for vector normalization: normalized_vector = vector * rsqrt(dot(vector, vector))
    /// More accurate than rsqrtFast() but slower
    pub fn rsqrt(self: FP) FP {
        if (self.raw_value <= 0) {
            std.debug.panic("rsqrt requires positive input", .{});
        }
        
        // Fast approximation, then one Newton-Raphson iteration
        const sqrt_approx = self.sqrtFast();
        return fp(1).div(sqrt_approx);
    }

    /// Ultra-fast reciprocal square root (1/sqrt(x)) for maximum performance
    /// Use for FPVector2 distance comparisons and when accuracy is less critical
    /// Fastest option but least accurate - skips Newton-Raphson refinement
    pub fn rsqrtFast(self: FP) FP {
        if (self.raw_value <= 0) {
            std.debug.panic("rsqrtFast requires positive input", .{});
        }
        
        // Get initial sqrt approximation
        const lz = @clz(self.raw_value);
        const shift = (64 - lz - PRECISION) / 2;
        const sqrt_guess = FP{ .raw_value = @as(i64, 1) << @intCast(PRECISION + shift) };
        
        // Return reciprocal directly without full Newton-Raphson
        return fp(1).div(sqrt_guess);
    }

    /// Trigonometric functions using Taylor series approximation

    /// Sine function using Taylor series
    pub fn sin(self: FP) FP {
        // Normalize angle to [-PI, PI] range
        var x = self.mod(TAU);
        if (x.gt(PI)) {
            x = x.sub(TAU);
        }
        
        // Taylor series: sin(x) = x - x^3/3! + x^5/5! - x^7/7! + ...
        const x2 = x.mul(x);
        const x3 = x2.mul(x);
        const x5 = x3.mul(x2);
        const x7 = x5.mul(x2);
        const x9 = x7.mul(x2);
        
        var result = x;
        result = result.sub(x3.div(fp(6)));           // -x^3/3!
        result = result.add(x5.div(fp(120)));         // +x^5/5!
        result = result.sub(x7.div(fp(5040)));        // -x^7/7!
        result = result.add(x9.div(fp(362880)));      // +x^9/9!
        
        return result;
    }

    /// Cosine function using Taylor series
    pub fn cos(self: FP) FP {
        // cos(x) = sin(x + PI/2)
        return self.add(PI_2).sin();
    }

    /// Tangent function
    pub fn tan(self: FP) FP {
        const sine = self.sin();
        const cosine = self.cos();
        return sine.div(cosine);
    }

    /// Arc sine function using polynomial approximation
    pub fn asin(self: FP) FP {
        const abs_x = self.abs();
        if (abs_x.gt(fp(1))) {
            std.debug.panic("asin input must be in range [-1, 1]", .{});
        }
        
        // For x near 1, use asin(x) = π/2 - sqrt(2*(1-x)) * (1 + c1*(1-x) + c2*(1-x)^2 + ...)
        if (abs_x.gt(fp(0.85))) {
            if (self.gt(fp(0))) {
                const one_minus_x = fp(1).sub(self);
                const sqrt_term = one_minus_x.mul(fp(2)).sqrt();
                // Approximation: π/2 - sqrt(2*(1-x)) * (1 + (1-x)/6)
                const correction = fp(1).add(one_minus_x.div(fp(6)));
                return PI_2.sub(sqrt_term.mul(correction));
            } else {
                // Use symmetry for negative values
                return self.negate().asin().negate();
            }
        }
        
        // Taylor series for smaller values: asin(x) ≈ x + x^3/6 + 3*x^5/40 + 5*x^7/112
        const x2 = self.mul(self);
        const x3 = x2.mul(self);
        const x5 = x3.mul(x2);
        const x7 = x5.mul(x2);
        
        var result = self;
        result = result.add(x3.div(fp(6)));
        result = result.add(x5.mul(fp(3)).div(fp(40)));
        result = result.add(x7.mul(fp(5)).div(fp(112)));
        
        return result;
    }

    /// Arc cosine function
    pub fn acos(self: FP) FP {
        return PI_2.sub(self.asin());
    }

    /// Arc tangent function using polynomial approximation
    pub fn atan(self: FP) FP {
        const abs_x = self.abs();
        
        // For |x| > 1, use atan(x) = π/2 - atan(1/x)
        if (abs_x.gt(fp(1))) {
            const reciprocal_atan = fp(1).div(abs_x).atan();
            const result = PI_2.sub(reciprocal_atan);
            return if (self.raw_value >= 0) result else result.negate();
        }
        
        // Taylor series for |x| <= 1: atan(x) = x - x^3/3 + x^5/5 - x^7/7 + ...
        const x2 = self.mul(self);
        const x3 = x2.mul(self);
        const x5 = x3.mul(x2);
        const x7 = x5.mul(x2);
        const x9 = x7.mul(x2);
        
        var result = self;
        result = result.sub(x3.div(fp(3)));
        result = result.add(x5.div(fp(5)));
        result = result.sub(x7.div(fp(7)));
        result = result.add(x9.div(fp(9)));
        
        return result;
    }

    /// Two-argument arc tangent function
    pub fn atan2(y: FP, x: FP) FP {
        if (x.gt(fp(0))) {
            return y.div(x).atan();
        } else if (x.lt(fp(0))) {
            if (y.gte(fp(0))) {
                return y.div(x).atan().add(PI);
            } else {
                return y.div(x).atan().sub(PI);
            }
        } else { // x == 0
            if (y.gt(fp(0))) {
                return PI_2;
            } else if (y.lt(fp(0))) {
                return PI_2.negate();
            } else {
                return fp(0); // undefined, but return 0
            }
        }
    }

    /// Logarithmic and exponential functions

    /// Natural exponential function e^x using Taylor series
    pub fn exp(self: FP) FP {
        // Handle large negative values to prevent underflow
        if (self.lt(fp(-10))) return fp(0);
        
        // Handle large positive values to prevent overflow
        if (self.gt(fp(10))) {
            std.debug.panic("exp overflow: input too large", .{});
        }
        
        // Taylor series: e^x = 1 + x + x^2/2! + x^3/3! + x^4/4! + ...
        const x2 = self.mul(self);
        const x3 = x2.mul(self);
        const x4 = x3.mul(self);
        const x5 = x4.mul(self);
        const x6 = x5.mul(self);
        
        var result = fp(1);                           // 1
        result = result.add(self);                    // + x
        result = result.add(x2.div(fp(2)));           // + x^2/2!
        result = result.add(x3.div(fp(6)));           // + x^3/3!
        result = result.add(x4.div(fp(24)));          // + x^4/4!
        result = result.add(x5.div(fp(120)));         // + x^5/5!
        result = result.add(x6.div(fp(720)));         // + x^6/6!
        
        return result;
    }

    /// Natural logarithm using series approximation
    pub fn ln(self: FP) FP {
        if (self.lte(fp(0))) {
            std.debug.panic("ln requires positive input", .{});
        }
        
        // For x close to 1, use ln(1+u) = u - u^2/2 + u^3/3 - u^4/4 + ...
        // Transform: ln(x) = ln((x-1+1)) = ln(1 + (x-1))
        const u = self.sub(fp(1));
        const abs_u = u.abs();
        
        if (abs_u.lt(fp(0.5))) {
            // Use Taylor series for ln(1+u)
            const u_squared = u.mul(u);
            const u_cubed = u_squared.mul(u);
            const u_fourth = u_cubed.mul(u);
            const u_fifth = u_fourth.mul(u);
            
            var result = u;                           // u
            result = result.sub(u_squared.div(fp(2)));       // - u^2/2
            result = result.add(u_cubed.div(fp(3)));       // + u^3/3
            result = result.sub(u_fourth.div(fp(4)));       // - u^4/4
            result = result.add(u_fifth.div(fp(5)));       // + u^5/5
            
            return result;
        } else {
            // For larger values, use properties of logarithms and iterative approach
            // This is a simplified approximation
            var x = self;
            var result = fp(0);
            
            // Reduce x to [1, 2) range using ln(2^n * x) = n*ln(2) + ln(x)
            while (x.gte(fp(2))) {
                x = x.div(fp(2));
                result = result.add(fromFloat(0.693147180559945)); // ln(2)
            }
            
            // Now use series for ln(x) where x is in [1, 2)
            const u_reduced = x.sub(fp(1));
            const u_reduced_squared = u_reduced.mul(u_reduced);
            const u_reduced_cubed = u_reduced_squared.mul(u_reduced);
            const u_reduced_fourth = u_reduced_cubed.mul(u_reduced);
            
            result = result.add(u_reduced);
            result = result.sub(u_reduced_squared.div(fp(2)));
            result = result.add(u_reduced_cubed.div(fp(3)));
            result = result.sub(u_reduced_fourth.div(fp(4)));
            
            return result;
        }
    }

    /// Base-2 logarithm
    pub fn log2(self: FP) FP {
        return self.ln().div(fromFloat(0.693147180559945)); // ln(2)
    }

    /// Base-10 logarithm
    pub fn log10(self: FP) FP {
        return self.ln().div(fromFloat(2.302585092994046)); // ln(10)
    }

    /// Power function x^y using exp(y * ln(x))
    pub fn pow(self: FP, exponent: FP) FP {
        if (self.lte(fp(0))) {
            if (self.eq(fp(0)) and exponent.gt(fp(0))) {
                return fp(0);
            }
            std.debug.panic("pow requires positive base for arbitrary exponents", .{});
        }
        
        // Special cases
        if (exponent.eq(fp(0))) return fp(1);
        if (exponent.eq(fp(1))) return self;
        if (self.eq(fp(1))) return fp(1);
        
        // Use exp(y * ln(x))
        const ln_x = self.ln();
        const y_ln_x = exponent.mul(ln_x);
        return y_ln_x.exp();
    }

    /// Integer power function (faster than general pow for integer exponents)
    pub fn powi(self: FP, exponent: i32) FP {
        if (exponent == 0) return fp(1);
        if (exponent == 1) return self;
        if (exponent == -1) return fp(1).div(self);
        
        var result = fp(1);
        var base = self;
        var abs_exp = if (exponent < 0) -exponent else exponent;
        
        // Fast exponentiation by squaring
        while (abs_exp > 0) {
            if (abs_exp & 1 != 0) {
                result = result.mul(base);
            }
            base = base.mul(base);
            abs_exp >>= 1;
        }
        
        return if (exponent < 0) fp(1).div(result) else result;
    }

    /// Advanced interpolation functions

    /// Smooth step interpolation (3t² - 2t³) for t ∈ [0,1]
    pub fn smoothstep(edge0: FP, edge1: FP, x: FP) FP {
        // Clamp x to [edge0, edge1]
        const t = x.sub(edge0).div(edge1.sub(edge0)).clamp01();
        
        // Apply smoothstep formula: 3t² - 2t³
        const t2 = t.mul(t);
        const t3 = t2.mul(t);
        return t2.mul(fp(3)).sub(t3.mul(fp(2)));
    }

    /// Smoother step interpolation (6t⁵ - 15t⁴ + 10t³) for t ∈ [0,1]
    /// Even smoother than smoothstep with zero first and second derivatives at edges
    pub fn smootherstep(edge0: FP, edge1: FP, x: FP) FP {
        // Clamp x to [edge0, edge1]
        const t = x.sub(edge0).div(edge1.sub(edge0)).clamp01();
        
        // Apply smootherstep formula: 6t⁵ - 15t⁴ + 10t³
        const t2 = t.mul(t);
        const t3 = t2.mul(t);
        const t4 = t3.mul(t);
        const t5 = t4.mul(t);
        
        return t5.mul(fp(6)).sub(t4.mul(fp(15))).add(t3.mul(fp(10)));
    }

    /// Cubic Hermite interpolation between two points with tangents
    /// p0, p1: control points, m0, m1: tangent vectors, t: interpolation parameter [0,1]
    pub fn hermite(p0: FP, p1: FP, m0: FP, m1: FP, t: FP) FP {
        const t2 = t.mul(t);
        const t3 = t2.mul(t);
        
        // Hermite basis functions
        const h00 = fp(2).mul(t3).sub(fp(3).mul(t2)).add(fp(1));  // 2t³ - 3t² + 1
        const h10 = t3.sub(fp(2).mul(t2)).add(t);                 // t³ - 2t² + t
        const h01 = fp(-2).mul(t3).add(fp(3).mul(t2));            // -2t³ + 3t²
        const h11 = t3.sub(t2);                                    // t³ - t²
        
        return h00.mul(p0).add(h10.mul(m0)).add(h01.mul(p1)).add(h11.mul(m1));
    }

    /// Catmull-Rom spline interpolation through 4 points
    /// Automatically computes tangents from neighboring points
    pub fn catmullRom(p0: FP, p1: FP, p2: FP, p3: FP, t: FP) FP {
        // Compute tangents: m1 = (p2 - p0) / 2, m2 = (p3 - p1) / 2
        const m1 = p2.sub(p0).div(fp(2));
        const m2 = p3.sub(p1).div(fp(2));
        
        return hermite(p1, p2, m1, m2, t);
    }

    /// Bezier cubic interpolation with 4 control points
    pub fn bezierCubic(p0: FP, p1: FP, p2: FP, p3: FP, t: FP) FP {
        const one_minus_t = fp(1).sub(t);
        const t2 = t.mul(t);
        const t3 = t2.mul(t);
        const one_minus_t2 = one_minus_t.mul(one_minus_t);
        const one_minus_t3 = one_minus_t2.mul(one_minus_t);
        
        // Bezier formula: (1-t)³P₀ + 3(1-t)²tP₁ + 3(1-t)t²P₂ + t³P₃
        var result = one_minus_t3.mul(p0);
        result = result.add(fp(3).mul(one_minus_t2).mul(t).mul(p1));
        result = result.add(fp(3).mul(one_minus_t).mul(t2).mul(p2));
        result = result.add(t3.mul(p3));
        
        return result;
    }

    /// Barycentric interpolation for 3 points (useful for triangular interpolation)
    /// Returns p0*u + p1*v + p2*w where u+v+w = 1
    pub fn barycentric(p0: FP, p1: FP, p2: FP, u: FP, v: FP, w: FP) FP {
        return p0.mul(u).add(p1.mul(v)).add(p2.mul(w));
    }

    /// Exponential decay interpolation: lerp with exponential easing
    pub fn expDecay(start: FP, end: FP, decay_rate: FP, dt: FP) FP {
        const factor = decay_rate.mul(dt).negate().exp();
        return end.add(start.sub(end).mul(factor));
    }

    /// String formatting
    pub fn format(
        self: FP,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        const sign_val: i64 = if (self.raw_value < 0) -1 else 1;
        const abs_value: u64 = @abs(self.raw_value);
        const integer_part = abs_value >> PRECISION;
        const fractional_part = abs_value & @as(u64, FRACTIONAL_MASK);

        // Convert fractional part to decimal (5 digits precision)
        const decimal_frac = (fractional_part * 100000) >> PRECISION;

        if (sign_val < 0) {
            try writer.writeByte('-');
        }
        try writer.print("{d}", .{integer_part});

        if (decimal_frac > 0) {
            // Remove trailing zeros
            var frac = decimal_frac;
            var digits: u32 = 5;
            while (frac % 10 == 0 and digits > 0) {
                frac /= 10;
                digits -= 1;
            }

            try writer.writeByte('.');
            // Pad with leading zeros if necessary
            var padding = digits;
            var temp = frac;
            while (temp > 0) {
                temp /= 10;
                padding -= 1;
            }
            while (padding > 0) : (padding -= 1) {
                try writer.writeByte('0');
            }
            try writer.print("{d}", .{frac});
        }
    }

    /// Parse from string
    pub fn fromString(str: []const u8) !FP {
        var trimmed = std.mem.trim(u8, str, " \t\n\r");
        if (trimmed.len == 0) return fp(0);

        var sign_val: i64 = 1;
        var idx: usize = 0;

        // Handle sign
        if (trimmed[0] == '-') {
            sign_val = -1;
            idx = 1;
        } else if (trimmed[0] == '+') {
            idx = 1;
        }

        // Find decimal point
        const decimal_pos = std.mem.indexOf(u8, trimmed[idx..], ".");
        
        var integer_part: i64 = 0;
        var fractional_part: i64 = 0;

        if (decimal_pos) |pos| {
            // Parse integer part
            if (pos > 0) {
                integer_part = try std.fmt.parseInt(i64, trimmed[idx..idx + pos], 10);
            }
            
            // Parse fractional part
            const frac_str = trimmed[idx + pos + 1..];
            if (frac_str.len > 0) {
                const frac_value = try std.fmt.parseInt(i64, frac_str, 10);
                var divisor: i64 = 1;
                
                // Calculate divisor based on number of decimal places
                var i: usize = 0;
                while (i < frac_str.len) : (i += 1) {
                    divisor *= 10;
                }
                
                // Convert to fixed-point fractional value
                fractional_part = @divTrunc(frac_value * ONE_RAW + @divTrunc(divisor, 2), divisor);
            }
        } else {
            // No decimal point, just integer
            integer_part = try std.fmt.parseInt(i64, trimmed[idx..], 10);
        }

        const raw = (integer_part << PRECISION) + fractional_part;
        return FP{ .raw_value = sign_val * raw };
    }

    /// Mathematical constants (users can't be expected to remember exact values)
    pub const PI = fromFloat(3.14159265358979323846);
    pub const TAU = fromFloat(6.28318530717958647693); // 2 * PI
    pub const E = fromFloat(2.71828182845904523536);
    pub const SQRT2 = fromFloat(1.41421356237309504880);
    pub const SQRT3 = fromFloat(1.73205080756887729352);
    
    // Angle conversion constants
    pub const DEG2RAD = fromFloat(0.01745329251994329577); // PI / 180
    pub const RAD2DEG = fromFloat(57.2957795130823208768); // 180 / PI
    
    // Common angles in radians
    pub const PI_2 = fromFloat(1.57079632679489661923); // PI / 2
    pub const PI_4 = fromFloat(0.78539816339744830962); // PI / 4
    pub const PI_3 = fromFloat(1.04719755119659774615); // PI / 3
    
    // Useful epsilon values for floating point comparisons
    pub const EPSILON = fromFloat(0.001);
    pub const SMALL_EPSILON = fromFloat(0.00001);
    
    // Min/max values
    pub const MIN_VALUE = FP{ .raw_value = std.math.minInt(i64) };
    pub const MAX_VALUE = FP{ .raw_value = std.math.maxInt(i64) };
    pub const USEABLE_MIN = FP{ .raw_value = @as(i64, std.math.minInt(i32)) << PRECISION };
    pub const USEABLE_MAX = FP{ .raw_value = @as(i64, std.math.maxInt(i32)) << PRECISION };
    pub const SMALLEST_NON_ZERO = FP{ .raw_value = 1 };
};

/// Convenience function for creating FP from integers
pub inline fn fp(value: anytype) FP {
    const T = @TypeOf(value);
    const info = @typeInfo(T);
    
    return switch (info) {
        .comptime_int => FP.fromInt(value),
        .comptime_float => FP.fromFloat(value),
        else => @compileError("fp() only accepts compile-time integers or floats. Use FP.fromFloatUnsafe() for runtime floats (breaks determinism!)"),
    };
}