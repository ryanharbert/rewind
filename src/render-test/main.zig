const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

// Engine imports
const Shader = @import("engine").Shader;
const Texture = @import("engine").Texture;
const Input = @import("engine").Input;
const math = @import("engine").math;
const AssetBundle = @import("engine").AssetBundle;
const Transform = @import("engine").Transform;
const SpriteRenderer = @import("engine").SpriteRenderer;
const Renderer = @import("engine").Renderer;

const vertex_shader_source =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\layout (location = 1) in vec2 aTexCoord;
    \\
    \\uniform float aspectRatio;
    \\
    \\out vec2 TexCoord;
    \\
    \\void main()
    \\{
    \\    vec3 correctedPos = aPos;
    \\    correctedPos.x /= aspectRatio;
    \\    gl_Position = vec4(correctedPos.x, correctedPos.y, correctedPos.z, 1.0);
    \\    TexCoord = aTexCoord;
    \\}
;

const fragment_shader_source =
    \\#version 330 core
    \\out vec4 FragColor;
    \\
    \\in vec2 TexCoord;
    \\uniform sampler2D ourTexture;
    \\
    \\void main()
    \\{
    \\    FragColor = texture(ourTexture, TexCoord);
    \\}
;

fn framebuffer_size_callback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    c.glViewport(0, 0, width, height);
}

// Profiling struct
const Profiler = struct {
    frame_count: u64,
    last_fps_time: f64,
    fps: f32,
    frame_time: f32,
    
    pub fn init() Profiler {
        return Profiler{
            .frame_count = 0,
            .last_fps_time = c.glfwGetTime(),
            .fps = 0.0,
            .frame_time = 0.0,
        };
    }
    
    pub fn update(self: *Profiler) void {
        self.frame_count += 1;
        const current_time = c.glfwGetTime();
        const delta = current_time - self.last_fps_time;
        
        if (delta >= 1.0) {
            self.fps = @as(f32, @floatCast(@as(f64, @floatFromInt(self.frame_count)) / delta));
            self.frame_time = @as(f32, @floatCast(delta / @as(f64, @floatFromInt(self.frame_count)) * 1000.0));
            self.frame_count = 0;
            self.last_fps_time = current_time;
            
            std.debug.print("FPS: {d:.1} | Frame Time: {d:.2}ms\n", .{ self.fps, self.frame_time });
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    if (c.glfwInit() == c.GLFW_FALSE) {
        std.debug.print("Failed to initialize GLFW\n", .{});
        return;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    const window = c.glfwCreateWindow(1200, 800, "Grapefruit Engine - Render Test", null, null);
    if (window == null) {
        std.debug.print("Failed to create GLFW window\n", .{});
        return;
    }
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    _ = c.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    // Initialize profiler
    var profiler = Profiler.init();

    // Create asset bundle and load test textures
    var bundle = AssetBundle.init(allocator);
    defer bundle.deinit();

    // For now, create a procedural texture - we'll add real sprites later
    const test_texture = try Texture.createTestSprite();
    defer test_texture.deinit();
    try bundle.textures.put(try allocator.dupe(u8, "test_sprite"), test_texture);

    // Create renderer
    var renderer = try Renderer.init(allocator, &bundle, vertex_shader_source, fragment_shader_source);
    defer renderer.deinit();

    // Initialize input system
    var input = Input.init(@ptrCast(window));
    
    // Create test entities - stress test with many sprites
    const NUM_SPRITES = 1000;
    var transforms = try allocator.alloc(Transform, NUM_SPRITES);
    defer allocator.free(transforms);
    var sprite_renderers = try allocator.alloc(SpriteRenderer, NUM_SPRITES);
    defer allocator.free(sprite_renderers);
    var velocities = try allocator.alloc(math.Vec2, NUM_SPRITES);
    defer allocator.free(velocities);

    // Initialize sprites with random positions and velocities
    var prng = std.Random.DefaultPrng.init(42);
    const random = prng.random();
    
    for (0..NUM_SPRITES) |i| {
        const x = random.float(f32) * 4.0 - 2.0; // -2 to 2
        const y = random.float(f32) * 4.0 - 2.0; // -2 to 2
        transforms[i] = Transform.init(x, y);
        transforms[i].setScale(0.1, 0.1); // Small sprites
        
        sprite_renderers[i] = SpriteRenderer.init("test_sprite");
        
        const vx = (random.float(f32) - 0.5) * 2.0; // -1 to 1
        const vy = (random.float(f32) - 0.5) * 2.0; // -1 to 1
        velocities[i] = math.Vec2.init(vx, vy);
    }

    var last_time = c.glfwGetTime();

    // Main loop
    while (c.glfwWindowShouldClose(window) == 0) {
        c.glfwPollEvents();
        
        // Update profiler
        profiler.update();
        
        // Update input
        input.update();
        
        // Calculate delta time
        const current_time = c.glfwGetTime();
        const delta_time = @as(f32, @floatCast(current_time - last_time));
        last_time = current_time;
        
        // Exit on escape
        if (input.isKeyPressed(.escape)) {
            c.glfwSetWindowShouldClose(window, c.GLFW_TRUE);
        }

        // Update sprite positions
        for (0..NUM_SPRITES) |i| {
            const movement = velocities[i].mul(delta_time);
            const movement_float = movement.toFloat();
            transforms[i].translate(movement_float.x, movement_float.y);
            
            // Bounce off screen edges
            const pos = transforms[i].position.toFloat();
            if (pos.x > 2.0 or pos.x < -2.0) {
                velocities[i].x = -velocities[i].x;
            }
            if (pos.y > 2.0 or pos.y < -2.0) {
                velocities[i].y = -velocities[i].y;
            }
        }

        // Render
        c.glClearColor(0.1, 0.1, 0.1, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        try renderer.render(transforms, sprite_renderers);

        c.glfwSwapBuffers(window);
    }
}