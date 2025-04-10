const std = @import("std");

pub fn identityMatrix(comptime T: type, comptime size: usize) [size][size]T {
    var matrix: [size][size]T = undefined;
    for (0..size) |i| {
        for (0..size) |j| {
            matrix[i][j] = if (i == j) 1 else 0;
        }
    }
    return matrix;
}

pub fn perspectiveMatrix(fov_degrees: f32, aspect_ratio: f32, near: f32, far: f32) [4][4]f32 {
    var matrix = identityMatrix(f32, 4);
    const fov_radians = fov_degrees * std.math.pi / 180.0;
    const tan_half_fov = std.math.tan(fov_radians / 2.0);

    matrix[0][0] = 1.0 / (aspect_ratio * tan_half_fov);
    matrix[1][1] = 1.0 / tan_half_fov;
    matrix[2][2] = -(far + near) / (far - near);
    matrix[2][3] = -1.0;
    matrix[3][2] = -(2.0 * far * near) / (far - near);
    matrix[3][3] = 0.0;

    return matrix;
} 