package mc

import blaze "mco_com_mojang:blaze3d"
import cm_math "mco_com_mojang:math"

PostPass :: struct
{
	
}




PostChain :: struct
{
	screen_target: blaze.RenderTarget,
	resmgr: ^ResourceManager,
	name: string,
	passes: [dynamic]PostPass,
	custom_render_targets: map[string]blaze.RenderTarget,
	full_sized_targets: [dynamic]blaze.RenderTarget,
	shader_ortho_matrix: cm_math.Matrix4f,

	screen_width, screen_height: int,
	time: f32,
	last_stamp: f32,
}

PostChain_init :: proc(this: ^PostChain)
{

}