pub const packages = struct {
    pub const @"122020d1ba277ff9e4b5ffff3e3bf4a3c98eeaec821e2a497d031070b05f7814b91f" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\122020d1ba277ff9e4b5ffff3e3bf4a3c98eeaec821e2a497d031070b05f7814b91f";
        pub const build_zig = @import("122020d1ba277ff9e4b5ffff3e3bf4a3c98eeaec821e2a497d031070b05f7814b91f");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "xcode_frameworks", "122051b3c616c62d55a82207c1cb76e2264b26e8378f56b1e5376d7684bd13616589" },
            .{ "vulkan_headers", "12209e716013e33618aaf5d915c6f2d196922b36aa16e06b52d7c28eafb2b3da0f4e" },
            .{ "wayland_headers", "1220552bb224e57205049e1c47be8d078a3dc09cb772c0c2e9dea09e452d0c5d6adf" },
            .{ "x11_headers", "12208aaa9355611470ae1357dfa2fd8c86e61679c2a9d343a8afaf25d3826a893111" },
        };
    };
    pub const @"122051b3c616c62d55a82207c1cb76e2264b26e8378f56b1e5376d7684bd13616589" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\122051b3c616c62d55a82207c1cb76e2264b26e8378f56b1e5376d7684bd13616589";
        pub const build_zig = @import("122051b3c616c62d55a82207c1cb76e2264b26e8378f56b1e5376d7684bd13616589");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"1220533928f944fe59f6dd2807db71cd69108cc810101e627835c3abcc4afea4fb06" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\1220533928f944fe59f6dd2807db71cd69108cc810101e627835c3abcc4afea4fb06";
        pub const build_zig = @import("1220533928f944fe59f6dd2807db71cd69108cc810101e627835c3abcc4afea4fb06");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "glfw", "122020d1ba277ff9e4b5ffff3e3bf4a3c98eeaec821e2a497d031070b05f7814b91f" },
        };
    };
    pub const @"1220552bb224e57205049e1c47be8d078a3dc09cb772c0c2e9dea09e452d0c5d6adf" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\1220552bb224e57205049e1c47be8d078a3dc09cb772c0c2e9dea09e452d0c5d6adf";
        pub const build_zig = @import("1220552bb224e57205049e1c47be8d078a3dc09cb772c0c2e9dea09e452d0c5d6adf");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"12208aaa9355611470ae1357dfa2fd8c86e61679c2a9d343a8afaf25d3826a893111" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\12208aaa9355611470ae1357dfa2fd8c86e61679c2a9d343a8afaf25d3826a893111";
        pub const build_zig = @import("12208aaa9355611470ae1357dfa2fd8c86e61679c2a9d343a8afaf25d3826a893111");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"12209e716013e33618aaf5d915c6f2d196922b36aa16e06b52d7c28eafb2b3da0f4e" = struct {
        pub const build_root = "C:\\Users\\ryanh\\AppData\\Local\\zig\\p\\12209e716013e33618aaf5d915c6f2d196922b36aa16e06b52d7c28eafb2b3da0f4e";
        pub const build_zig = @import("12209e716013e33618aaf5d915c6f2d196922b36aa16e06b52d7c28eafb2b3da0f4e");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "mach_glfw", "1220533928f944fe59f6dd2807db71cd69108cc810101e627835c3abcc4afea4fb06" },
};
