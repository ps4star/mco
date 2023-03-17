package mc

import j_func "mco_java:util/function"

import cm_math "mco_com_mojang:math"
import blaze "mco_com_mojang:blaze3d"

import mc_common "mco:mc/common"

GuiComponent :: struct
{
	blit_offset: int,
}

GuiComponent_fill :: proc(this: ^GuiComponent, ps: ^blaze.PoseStack, i1, i2, i3, i4, i5: int)
{
	GuiComponent_inner_fill(this, blaze.PoseStack_get_last(ps).pose, i1, i2, i3, i4, i5)
}

GuiComponent_inner_fill :: proc(this: ^GuiComponent, m4f: cm_math.Matrix4f, i1, i2, i3, i4, i5: int)
{
	i1 := i1
	i2 := i2
	i3 := i3
	i4 := i4
	i5 := i5

	if i1 < i3
	{
		_i := i1
		i1 = i3
		i3 = _i
	}

	if i2 < i4
	{
		j := i2
		i2 = i4
		i4 = j
	}

	f3 := f32(i5 >> 24 & 255) / 255.0
	f := f32(i5 >> 16 & 255) / 255.0
	f1 := f32(i5 >> 8 & 255) / 255.0
	f2 := f32(i5 & 255) / 255.0

	buf_builder := &(blaze.Tesselator_get_instance().builder)
	blaze.RenderSystem_enable_blend()
	blaze.RenderSystem_disable_texture()
	blaze.RenderSystem_default_blend_func()
	blaze.RenderSystem_set_shader(j_func.Supplier(^mc_common.ShaderInstance){
		// ctx = nil,
		get = proc(_: rawptr) -> (^mc_common.ShaderInstance) { return position_color_shader }
	})

	// IMPL
}

Gui :: struct
{
	/*using */gcomp: GuiComponent,

	minecraft: ^Minecraft,

	tick_count: int,
	overlay_message_time: int,
	animate_overlay_message_color: bool,
	chat_disabled_by_player_shown: bool,
	vignette_brightness: f32,
	tool_highlight_timer: int,
	
	last_tool_highlight: ^ItemStack,

	title_time: int,
	title, subtitle: ^Component,

	autosave_indicator_value: f32,
	last_autosave_indicator_value: f32,
}

Gui_tick_flag :: proc(this: ^Gui, flag: bool)
{
	// this.tickAutoSaveIndicator()
	if !flag {
		Gui_tick(this)
	}
}
Gui_tick_no_flag :: proc(this: ^Gui)
{
	if this.overlay_message_time > 0 {
		this.overlay_message_time -= 1
	}

	if this.title_time > 0 {
		this.title_time -= 1
		if this.title_time <= 0 {
			this.title = nil
			this.subtitle = nil
		}
	}

	this.tick_count += 1

	/*cam_ent := Minecraft_get_camera_entity(this.minecraft)
	if cam_ent != nil {
		Gui_update_vignette_brightness(cam_ent)
	}

	if this.minecraft.player != nil {
		istack := Inventory_get_selected(this.minecraft.player.inventory)
	}*/
}
Gui_tick :: proc{
	Gui_tick_flag,
	Gui_tick_no_flag,
}

Gui_tick_autosave_indicator :: proc(this: ^Gui)
{
    mcserv := &(Minecraft_get_single_player_server(this.minecraft).minecraft_server)
    flag := (mcserv != nil && mcserv.is_saving)
    this.last_autosave_indicator_value = this.autosave_indicator_value
    this.autosave_indicator_value = mc_common.lerp(f32(0.2), this.autosave_indicator_value, f32(1.0) if flag else f32(0.0))
}