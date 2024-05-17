shader_type spatial;

uniform float red_influence_factor: hint_range(0.0, 10.0) = 1.0;
uniform float blue_influence_factor: hint_range(0.0, 10.0) = 1.0;
uniform float green_influence_factor: hint_range(0.0, 10.0) = 1.0;
uniform float noise_strength: hint_range(0.0, 1.0) = 1.0;

group_uniforms textures;
uniform sampler2D gradient_texture: source_color;
uniform sampler2D mask_texture;
uniform sampler2D noise_texture;

void fragment() {
	vec3 mask_color = texture(mask_texture, UV).rgb;
	float noise_value = texture(noise_texture, UV).r;
	
	vec3 normalized_rgb_ratio = normalize(vec3(red_influence_factor, blue_influence_factor, green_influence_factor));
	
	float weighted_rgb_sum = 
	(mask_color.r * normalized_rgb_ratio.r) + 
	(mask_color.g * normalized_rgb_ratio.g) + 
	(mask_color.b * normalized_rgb_ratio.b);
	
	float uv_factor = 
	clamp(
	weighted_rgb_sum * noise_strength * noise_value + (1.0 - noise_strength) * weighted_rgb_sum
	,0.01, 0.99);
	
	vec3 gradient_color = texture(gradient_texture, vec2(uv_factor)).rgb;
	vec3 final_color = gradient_color.rgb;
	
	ALBEDO = final_color;
}
