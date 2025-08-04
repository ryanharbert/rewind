@vs sprite_vs
@glsl_options flip_vert_y

in vec2 a_pos;
in vec4 a_inst_pos_size;
in vec4 a_inst_color;

out vec2 uv;
out vec4 color;

uniform vs_params {
    mat4 u_projection;
};

void main() {
    // Create sprite quad from instance data
    vec2 pos = a_inst_pos_size.xy + a_pos * a_inst_pos_size.zw;
    gl_Position = u_projection * vec4(pos, 0.0, 1.0);
    
    // Pass through UV and color
    uv = a_pos; // 0-1 range from vertex position
    color = a_inst_color;
}
@end

@fs sprite_fs
in vec2 uv;
in vec4 color;

out vec4 frag_color;

uniform texture2D u_tex;
uniform sampler u_smp;

void main() {
    frag_color = texture(sampler2D(u_tex, u_smp), uv) * color;
}
@end

@program sprite sprite_vs sprite_fs