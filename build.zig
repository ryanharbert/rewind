const std = @import("std");

pub fn build(b: *std.Build) void {
    // Target Windows x86_64
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .windows,
    });
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "Grapefruit",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add GLFW library for Windows
    exe.addIncludePath(b.path("libs/glfw/glfw-3.4.bin.WIN64/include"));
    exe.addObjectFile(b.path("libs/glfw/glfw-3.4.bin.WIN64/lib-mingw-w64/libglfw3.a"));
    exe.linkSystemLibrary("opengl32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("kernel32");

    // Add GLAD
    exe.addIncludePath(b.path("libs/glad/include"));
    exe.addCSourceFile(.{ 
        .file = b.path("libs/glad/src/glad.c"),
        .flags = &.{"-std=c99"}
    });
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
