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

const default_vertex_shader =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\layout (location = 1) in vec2 aTexCoord;
    \\
    \\out vec2 TexCoord;
    \\
    \\void main()
    \\{
    \\    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
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
        
        if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
            c.glfwDestroyWindow(window);
            c.glfwTerminate();
            return error.GLADInitFailed;
        }
        
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