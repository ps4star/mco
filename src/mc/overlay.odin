package mc

import blaze "mco:extern/com_mojang/blaze3d"

import mc_common "mco:mc/common"

LoadingOverlay :: struct
{
	using gcomp: GuiComponent,
	minecraft: ^Minecraft,

	progress: f32,
	res_list: []PackResources,

	fade_in: bool,

	fade_out_start: i64, // -1
	fade_in_start: i64, // -1
}

LoadingOverlay_init :: proc(this: ^LoadingOverlay, minecraft: ^Minecraft)
{
	this.minecraft = minecraft

	// Defaults
	this.fade_in_start = -1
	this.fade_out_start = -1
}

LoadingOverlay_render :: proc(this: ^LoadingOverlay, ps: ^blaze.PoseStack, w, h: int, delta: f32)
{
	i := this.minecraft.window.gui_scaled_width
	j := this.minecraft.window.gui_scaled_height
	k := mc_common.Util_get_millis.get(nil)

	if this.fade_in && this.fade_in_start == -1
	{
		this.fade_in_start = k
	}

	f := (f32(k - this.fade_out_start) / 1000.0) if this.fade_out_start > -1 else f32(-1.0)
	f1 := (f32(k - this.fade_in_start) / 500.0) if this.fade_in_start > -1 else f32(-1.0)
	f2: f32

	if f >= 1.0
	{
		if this.minecraft.screen != nil
		{
			// render MC screen
		}

		l := mc_common.ceil((1.0 - clamp(f - 1.0, 0.0, 1.0)) * 255.0)
	}
}