const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

// Re-export engine modules for external use
pub const math = @import("math.zig");
pub const Input = @import("input.zig").Input;
pub const Transform = @import("transform.zig").Transform;
pub const SpriteRenderer = @import("sprite_renderer.zig").SpriteRenderer;
pub const Renderer = @import("renderer.zig").Renderer;
pub const Texture = @import("texture.zig").Texture;
pub const Shader = @import("shader.zig").Shader;
pub const AssetBundle = @import("asset_bundle.zig").AssetBundle;
pub const Camera = @import("camera.zig").Camera;

const default_vertex_shader =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\layout (location = 1) in vec2 aTexCoord;
    \\
    \\uniform mat4 viewMatrix;
    \\
    \\out vec2 TexCoord;
    \\
    \\void main()
    \\{
    \\    gl_Position = viewMatrix * vec4(aPos, 1.0);
    \\    TexCoord = aTexCoord;
    \\}
;

const default_fragment_shader =
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

pub const EngineConfig = struct {
    window_width: i32 = 1200,
    window_height: i32 = 800,
    window_title: []const u8 = "Grapefruit Engine",
    vertex_shader: []const u8 = default_vertex_shader,
    fragment_shader: []const u8 = default_fragment_shader,
    clear_color: [4]f32 = .{ 0.2, 0.3, 0.3, 1.0 },
};

pub const Engine = struct {
    allocator: std.mem.Allocator,
    window: ?*c.GLFWwindow,
    input: Input,
    asset_bundle: *AssetBundle,
    renderer: Renderer,
    config: EngineConfig,
    
    // FPS tracking
    fps_counter: f64,
    fps_timer: f64,
    frame_count: u32,
    debug_timer: f64,
    
    pub fn init(allocator: std.mem.Allocator, config: EngineConfig) !Engine {
        if (c.glfwInit() == c.GLFW_FALSE) {
            return error.GLFWInitFailed;
        }
        
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
        
        const window = c.glfwCreateWindow(
            config.window_width,
            config.window_height,
            config.window_title.ptr,
            null,
            null
        ) orelse {
            c.glfwTerminate();
            return error.WindowCreationFailed;
        };
        
        c.glfwMakeContextCurrent(window);
        _ = c.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
        
        // Enable VSync to cap framerate
        c.glfwSwapInterval(1);
        
        if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
            c.glfwDestroyWindow(window);
            c.glfwTerminate();
            return error.GLADInitFailed;
        }
        
        // Enable alpha blending for transparency
        c.glEnable(c.GL_BLEND);
        c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);
        
        const asset_bundle = try allocator.create(AssetBundle);
        asset_bundle.* = AssetBundle.init(allocator);
        const renderer = try Renderer.init(allocator, asset_bundle, config.vertex_shader, config.fragment_shader);
        const input = Input.init(@ptrCast(window));
        
        return Engine{
            .allocator = allocator,
            .window = window,
            .input = input,
            .asset_bundle = asset_bundle,
            .renderer = renderer,
            .config = config,
            .fps_counter = 0.0,
            .fps_timer = 0.0,
            .frame_count = 0,
            .debug_timer = 0.0,
        };
    }
    
    pub fn deinit(self: *Engine) void {
        self.renderer.deinit();
        self.asset_bundle.deinit();
        self.allocator.destroy(self.asset_bundle);
        if (self.window) |window| {
            c.glfwDestroyWindow(window);
        }
        c.glfwTerminate();
    }
    
    pub fn shouldClose(self: *Engine) bool {
        return c.glfwWindowShouldClose(self.window) != 0;
    }
    
    pub fn run(self: *Engine, comptime App: type, app: *App) !void {
        var last_time = c.glfwGetTime();
        
        while (!self.shouldClose()) {
            c.glfwPollEvents();
            
            // Update input
            self.input.update();
            
            // Calculate delta time
            const current_time = c.glfwGetTime();
            const delta_time = @as(f32, @floatCast(current_time - last_time));
            last_time = current_time;
            
            // Update FPS counter
            self.frame_count += 1;
            self.fps_timer += delta_time;
            self.debug_timer += delta_time;
            
            // Calculate FPS every second
            if (self.fps_timer >= 1.0) {
                self.fps_counter = @as(f64, @floatFromInt(self.frame_count)) / self.fps_timer;
                self.frame_count = 0;
                self.fps_timer = 0.0;
            }
            
            // Print debug info every 3 seconds
            if (self.debug_timer >= 3.0) {
                std.debug.print("\n=== PERFORMANCE DEBUG ===\n", .{});
                std.debug.print("Current FPS: {d:.1}\n", .{self.fps_counter});
                std.debug.print("Frame time: {d:.2}ms\n", .{(1.0 / self.fps_counter) * 1000.0});
                std.debug.print("Delta time: {d:.3}ms\n", .{delta_time * 1000.0});
                
                // GPU info
                var gpu_memory: c_int = undefined;
                c.glGetIntegerv(0x9049, &gpu_memory); // GL_GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX
                if (gpu_memory > 0) {
                    std.debug.print("GPU Memory Available: {}KB\n", .{gpu_memory});
                }
                
                std.debug.print("Sprites rendered per frame: 3 (background + player + enemy)\n", .{});
                std.debug.print("Draw calls per frame: 3 (individual textures)\n", .{});
                std.debug.print("========================\n", .{});
                self.debug_timer = 0.0;
            }
            
            // Exit on escape
            if (self.input.isKeyPressed(.escape)) {
                c.glfwSetWindowShouldClose(self.window, c.GLFW_TRUE);
            }
            
            // Update app
            if (@hasDecl(App, "update")) {
                app.update(&self.input, delta_time);
            }
            
            // Clear screen
            const color = self.config.clear_color;
            c.glClearColor(color[0], color[1], color[2], color[3]);
            c.glClear(c.GL_COLOR_BUFFER_BIT);
            
            // Render app
            if (@hasDecl(App, "render")) {
                try app.render(&self.renderer);
            }
            
            c.glfwSwapBuffers(self.window);
        }
    }
    
    pub fn getAssetBundle(self: *Engine) *AssetBundle {
        return self.asset_bundle;
    }
    
    pub fn getRenderer(self: *Engine) *Renderer {
        return &self.renderer;
    }
    
    pub fn getInput(self: *Engine) *Input {
        return &self.input;
    }
};