shader_type canvas_item;
uniform bool is_white;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	if(is_white){
		vec4 new_texture;
		if(COLOR.a > 0.0){
			new_texture = vec4(1.0, 1.0, 1.0, 1.0);
		}
		else{
			new_texture = vec4(1.0, 1.0, 1.0, 0.0);
		}
		COLOR = new_texture;
	}
}