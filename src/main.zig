const std = @import("std");
const render_test = @import("render-test/main.zig");

pub fn main() !void {
    try render_test.main();
}
