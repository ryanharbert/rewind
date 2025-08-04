const std = @import("std");
const sokol = @import("sokol");
const sg = sokol.gfx;
const assets = @import("assets.zig");
const shd = @import("sprite_shader.glsl.zig");

pub const Vec2 = struct {
    x: f32,
    y: f32,
};

pub const Color = struct {
    r: f32 = 1.0,
    g: f32 = 1.0,
    b: f32 = 1.0,
    a: f32 = 1.0,
};

// Simple sprite - just position, size, color, and texture
pub const Sprite = struct {
    position: Vec2,
    size: Vec2,
    color: Color = .{},
    texture_id: u32,
};

// Instance data sent to GPU per sprite
const SpriteInstance = struct {
    pos_size: [4]f32, // x, y, width, height
    color: [4]f32,    // r, g, b, a
};

const MAX_SPRITES = 10000;

// Quad vertices (two triangles)
const quad_vertices = [_]f32{
    0.0, 0.0,  // Bottom-left
    1.0, 0.0,  // Bottom-right
    1.0, 1.0,  // Top-right
    0.0, 0.0,  // Bottom-left
    1.0, 1.0,  // Top-right
    0.0, 1.0,  // Top-left
};

pub const SpriteRenderer = struct {
    allocator: std.mem.Allocator,
    
    // GPU resources
    shader: sg.Shader,
    pipeline: sg.Pipeline,
    vertex_buffer: sg.Buffer,
    instance_buffer: sg.Buffer,
    sampler: sg.Sampler,
    
    // Textures
    textures: std.ArrayList(sg.Image),
    
    // Current frame sprites
    sprites: std.ArrayList(Sprite),
    
    pub fn init(allocator: std.mem.Allocator) !SpriteRenderer {
        // Create vertex buffer for quad
        const vertex_buffer = sg.makeBuffer(.{
            .data = sg.asRange(&quad_vertices),
        });
        
        // Create dynamic instance buffer
        const instance_buffer = sg.makeBuffer(.{
            .size = MAX_SPRITES * @sizeOf(SpriteInstance),
            .usage = .{ .dynamic_update = true },
        });
        
        // Create shader using the standard sokol approach
        const shader = sg.makeShader(shd.spriteShaderDesc(sg.queryBackend()));
        
        // Create sampler for texture sampling
        const sampler = sg.makeSampler(.{
            .min_filter = .LINEAR,
            .mag_filter = .LINEAR,
            .wrap_u = .CLAMP_TO_EDGE,
            .wrap_v = .CLAMP_TO_EDGE,
        });
        
        // Create pipeline
        var pip_desc = sg.PipelineDesc{
            .shader = shader,
            .color_count = 1,
        };
        pip_desc.colors[0].blend = .{
            .enabled = true,
            .src_factor_rgb = .SRC_ALPHA,
            .dst_factor_rgb = .ONE_MINUS_SRC_ALPHA,
        };
        
        // Vertex layout - must match shader attributes
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_pos] = .{ .format = .FLOAT2 }; // vertex position
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_inst_pos_size] = .{ .format = .FLOAT4, .buffer_index = 1 }; // instance pos_size
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_inst_color] = .{ .format = .FLOAT4, .buffer_index = 1 }; // instance color
        pip_desc.layout.buffers[1].step_func = .PER_INSTANCE;
        
        const pipeline = sg.makePipeline(pip_desc);
        
        return SpriteRenderer{
            .allocator = allocator,
            .shader = shader,
            .pipeline = pipeline,
            .vertex_buffer = vertex_buffer,
            .instance_buffer = instance_buffer,
            .sampler = sampler,
            .textures = std.ArrayList(sg.Image).init(allocator),
            .sprites = std.ArrayList(Sprite).init(allocator),
        };
    }
    
    pub fn deinit(self: *SpriteRenderer) void {
        sg.destroyBuffer(self.vertex_buffer);
        sg.destroyBuffer(self.instance_buffer);
        sg.destroyPipeline(self.pipeline);
        sg.destroyShader(self.shader);
        sg.destroySampler(self.sampler);
        
        for (self.textures.items) |texture| {
            sg.destroyImage(texture);
        }
        self.textures.deinit();
        self.sprites.deinit();
    }
    
    pub fn loadTexture(self: *SpriteRenderer, image: assets.Image) !u32 {
        const sg_image = sg.makeImage(.{
            .width = @intCast(image.width),
            .height = @intCast(image.height),
            .pixel_format = .RGBA8,
            .data = .{
                .subimage = .{
                    .{ .{ .ptr = image.data.ptr, .size = image.data.len }, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                },
            },
        });
        
        try self.textures.append(sg_image);
        return @intCast(self.textures.items.len - 1);
    }
    
    pub fn drawSprite(self: *SpriteRenderer, sprite: Sprite) !void {
        try self.sprites.append(sprite);
    }
    
    pub fn render(self: *SpriteRenderer, projection: [16]f32) void {
        if (self.sprites.items.len == 0) return;
        
        // Build instance data
        var instances: [MAX_SPRITES]SpriteInstance = undefined;
        for (self.sprites.items, 0..) |sprite, i| {
            instances[i] = .{
                .pos_size = .{ sprite.position.x, sprite.position.y, sprite.size.x, sprite.size.y },
                .color = .{ sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a },
            };
        }
        
        // Update instance buffer
        const instance_data = instances[0..self.sprites.items.len];
        sg.updateBuffer(self.instance_buffer, sg.asRange(instance_data));
        
        // Apply pipeline
        sg.applyPipeline(self.pipeline);
        
        // Set projection matrix using shader's uniform slot
        sg.applyUniforms(shd.SLOT_vs_params, sg.asRange(&projection));
        
        // For now, draw all sprites with first texture (we'll optimize this later)
        if (self.textures.items.len > 0) {
            sg.applyBindings(.{
                .vertex_buffers = .{ self.vertex_buffer, self.instance_buffer, .{}, .{}, .{}, .{}, .{}, .{} },
                .images = .{ self.textures.items[0], .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                .samplers = .{ self.sampler, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
            });
            
            // Draw instanced: 6 vertices per quad, N instances
            sg.draw(0, 6, @intCast(self.sprites.items.len));
        }
        
        // Clear for next frame
        self.sprites.clearRetainingCapacity();
    }
};