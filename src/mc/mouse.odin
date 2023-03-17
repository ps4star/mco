package mc
import j_lang "mco:java/lang"
import j_misc "mco:java/misc"

import blaze "mco:extern/com_mojang/blaze3d"

import mc_common "mco:mc/common"

MouseHandler :: struct
{
	minecraft: ^Minecraft,

	is_left_pressed, is_middle_pressed, is_right_pressed: bool,
	xpos, ypos: f64,
	fake_right_mouse: int,
	active_button: int, // -1
	ignore_first_move: bool, // true
	click_depth: int,
	mouse_pressed_time: f64,

	smooth_turn_x, smooth_turn_y: mc_common.SmoothF64,

	acc_dx, acc_dy: f64,
	acc_scroll: f64,
	last_mouse_event_time: f64, // MIN_VALUE
	mouse_grabbed: bool,
}

MouseHandler_init :: proc(this: ^MouseHandler, minecraft: ^Minecraft)
{
	this.active_button = -1
	this.ignore_first_move = true

	this.last_mouse_event_time = j_misc.DOUBLE_MIN_VALUE

	this.smooth_turn_x = { 0.0, 0.0, 0.0 }
	this.smooth_turn_y = { 0.0, 0.0, 0.0 }

	this.minecraft = minecraft
}

MouseHandler_setup :: proc(this: ^MouseHandler, win_hnd: blaze.WindowHandle)
{
	// IMPL
}

MouseHandler_turn_player :: proc(this: ^MouseHandler)
{
	// IMPL
}