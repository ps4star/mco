package mc
import gson "mco_extern:com_google/gson"

import blaze			"mco_com_mojang:blaze3d"
import cm_ser			"mco_com_mojang:datafixerupper/serialization"

import j_io				"mco_java:io"
import j_misc			"mco_java:misc"

import global "mco:odin/global"

// SPECIFIC OPTION OBJECTS
CameraType :: struct
{
	first_person: bool,
	mirrored: bool,
	_num: uint,
}

@private CameraType_NUM_VALUES :: 3
CameraType_FirstPerson			:= CameraType{ true, false, 0 }
CameraType_ThirdPersonBack		:= CameraType{ false, false, 1 }
CameraType_ThirdPersonFront		:= CameraType{ false, true, 2 }

// Length of this should match the number of CameraType presets defined above ^
@private CameraType_VALUES := [CameraType_NUM_VALUES]^CameraType{ &CameraType_FirstPerson, &CameraType_ThirdPersonBack, &CameraType_ThirdPersonFront }
CameraType_cycle :: proc(this: ^CameraType, out: ^CameraType)
{
	out^ = ( CameraType_VALUES[(this._num + 1) % CameraType_NUM_VALUES] )^
}







// OPTION UTIL
/*ValueSetDisplayType :: enum uint
{
	Button,
	Slider,
}

ValueSet :: struct($T: typeid)
{
	real_min, real_max: T,

	/*visual_min, visual_max: T,
	granularity: T,

	type: ValueSetDisplayType,*/
}










// OPTION INSTANCE
OptionInstanceDisplayType :: enum
{

}

OptionInstance :: struct($T: typeid)
{
	to_string: proc(^Component, T) -> (string),
	to_comp: proc(^Component, T) -> (^Component),

	display_type: OptionInstanceDisplayType,
	values: ValueSet(T),
	initial_value: T,
	on_value_update: proc(T), // @NoContextNeeded
	caption: ^Component,
	value: T,
}

// CaptionBasedToComponentProc :: #type proc(comp: ^Component, data: $T) -> (^Component)
Tooltip :: []FmtCharSeq
OptionInstance_NO_TOOLTIP := Tooltip{} // empty (non-nil) slice

OptionInstance_init_no_codec :: proc(this: ^OptionInstance($T),
	name: string,
	tooltip: Tooltip,
	caption_to_component: proc(^Component, T) -> (^Component),
	vs: ValueSet(T),
	initial: T,
	consumer: proc(T))
{
	vs := vs
	OptionInstance_init_codec(name, tooltip, caption_to_component, vs, vs.codec(&vs), initial, consumer)
}

OptionInstance_init_codec :: proc(this: ^OptionInstance($T),
	name: string,
	tooltip: Tooltip,
	caption_to_component: proc(^Component, T) -> (^Component),
	vs: ValueSet(T),
	codec: cm_ser.Codec($T2),
	initial: T,
	consumer: proc(T))
{
	this.caption = Component_translatable(name)
	this.tooltip = tooltip
	this.to_comp = caption_to_component

	this.to_string = proc(_this: rawptr, val: T) -> (string)
	{
		this := (^OptionInstance)(this)
		return this.to_comp(this.caption, val)
	}

	this.values = vs
	this.codec = codec
	this.initial_value = initial
	this.on_value_update = consumer
	this.value = this.initial_value
}

OptionInstance_init :: proc{
	OptionInstance_init_no_codec,
	OptionInstance_init_codec,
}

OptionInstance_get :: #force_inline proc(this: ^OptionInstance($T)) -> (T)
{
	return this.value
}*/

/*OptionInstance_new :: #force_inline proc($T: typeid) -> (out: OptionInstance(T))
{
	OptionInstance_init(&out)
	return
}*/





Tooltip :: []FmtCharSeq
NO_TOOLTIP := Tooltip{} // empty (non-nil) slice

OptionInstance :: struct($T, $T2: typeid)
{
	comp: ^Component,
	tooltip: Tooltip,

	to_string: proc(^Component, T) -> (^Component),

	val, initial_val: T,
	min_val: Maybe(T), // if nil, no min
	max_val: Maybe(T), // if nil, no max

	max_provider: proc(rawptr) -> (Maybe(T)),
	validate_val: proc(rawptr, T) -> (Maybe(T)),

	serial_codec: cm_ser.Codec(T, T2),
	on_update: proc(T),
}

// OPTIONS
Options_Gson: gson.Gson
Options :: struct
{
	gui_scale: OptionInstance(int, int), // @DynamicDefault

	dark_mojang_studios_background: OptionInstance(bool, bool), // @DynamicDefault
	hide_lightning_flash: OptionInstance(bool, bool), // @DynamicDefault
	sensitivity: OptionInstance(f64, f64), // @DynamicDefault
	render_distance: OptionInstance(int, int),
	simulation_distance: OptionInstance(int, int),

	server_render_distance: int, // @StaticDefault (0)

	entity_distance_scaling: OptionInstance(f64, f64), // @DynamicDefault
	framerate_limit: OptionInstance(int, int), // @DynamicDefault
	cloud_status: OptionInstance(CloudStatus, CloudStatus), // @DynamicDefault

	options_file: j_io.File,
	hide_gui: bool,
	camera_type: CameraType,

	render_debug: bool,
	render_debug_charts: bool,
	render_fps_chart: bool,

	override_width, override_height: int,

	last_multiplayer_ip: string,
	smooth_camera: bool,

	fov: OptionInstance(int, f64),

	force_unicode_font: OptionInstance(bool, bool), // @DynamicDefault

	fullscreen_video_mode_string: string,

	gl_debug_verbosity: int, // 1
}
@private Options_DEFAULT := Options{
	server_render_distance = 0,
	camera_type = CameraType_FirstPerson,
}

// Serialization procs
when true { // for sublime text hiding purposes
	// FOV
	str_fov :: proc(in_comp: ^Component, i: int) -> (comp: ^Component)
	{
		// comp: ^Component
		switch i {
		case 70:
			comp = Options_generic_value_label(in_comp, Component_translatable("options.fov.min"))

		case 110:
			comp = Options_generic_value_label(in_comp, Component_translatable("options.fov.max"))

		case:
			comp = Options_generic_value_label(in_comp, i)
		}
		return comp
	}

	r_fov :: proc(_this: rawptr, val: f64) -> (int)
	{
		return cast(int) (val * 40.0 + 70.0)
	}

	w_fov :: proc(_this: rawptr, val: int) -> (f64)
	{
		return f64(val - 70.0) / 40.0
	}

	up_fov :: proc(val: int)
	{
		LevelRenderer_needs_update(&(Minecraft_INST.level_renderer))
	}


	// GUI SCALE
	str_gui_scale :: proc(comp: ^Component, val: int) -> (^Component)
	{
		return Component_translatable("options.guiScale.auto") if val == 0 else Component_literal(j_misc.int_to_string(val))
	}

	max_gui_scale :: proc(_: rawptr) -> (Maybe(int))
	{
		if !(Minecraft_INST.running) {
			return cast(int) 2_147_483_646
		}
		return blaze.Window_calculate_scale(&(Minecraft_INST.window), 0, Minecraft_is_enforce_unicode(Minecraft_INST))
	}

	r_gui_scale :: proc(_this: rawptr, val: int) -> (int)
	{
		this := (^OptionInstance(int, int))(_this)
		i := this.max_provider(nil).? + 1
		// assert()
		return 0
	}

	w_gui_scale :: proc(_this: rawptr, val: int) -> (int)
	{
		this := (^OptionInstance(int, int))(_this)
		return 0
	}


	// FORCE UNICODE FONT
	up_force_unicode_font :: proc(val: bool)
	{
		// NOTE: This condition is always true so it can be omitted
		// if Minecraft_INST.window != nil {
			Minecraft_select_main_font(Minecraft_INST, val)
			Minecraft_resize_display(Minecraft_INST)
		// }
	}
}

Options_INIT :: proc()
{
	make_bool_opt_base :: proc(out: ^OptionInstance(bool, bool), compstr: string, tt: Tooltip, initial_val: bool, consumer: proc(bool))
	{
		out^ = {
			comp = Component_translatable(compstr),
			tooltip = tt,
			initial_val = initial_val, min_val = nil, max_val = nil,

			to_string = proc(comp: ^Component, b: bool) -> (^Component)
			{
				return common_components[.OptionOn] if b else common_components[.OptionOff]
			}
		}
	}
	make_bool_opt_no_tooltip :: #force_inline proc(out: ^OptionInstance(bool, bool), compstr: string, initial_val: bool, consumer: proc(bool))
	{
		make_bool_opt_base(out, compstr, NO_TOOLTIP, initial_val, consumer)
	}
	make_bool_opt :: proc{
		make_bool_opt_base,
		make_bool_opt_no_tooltip,
	}

	this := &(Options_DEFAULT)
	this.fov = {
		comp = Component_translatable("options.fov"),
		tooltip = NO_TOOLTIP,
		initial_val = 70, min_val = Maybe(int) (30), max_val = Maybe(int) (110),

		to_string = str_fov,
		serial_codec = { r_fov, w_fov },
		on_update = up_fov,
	}

	this.gui_scale = {
		comp = Component_translatable("options.guiScale"),
		tooltip = NO_TOOLTIP,
		initial_val = 0, min_val = Maybe(int) (nil), max_val = Maybe(int) (nil),

		max_provider = max_gui_scale,

		to_string = str_fov,
		serial_codec = { r_gui_scale, w_gui_scale },
		on_update = up_fov,
	}

	make_bool_opt(&(this.force_unicode_font), "options.forceUnicodeFont", false, up_force_unicode_font)

	// Static defaults
	this.gl_debug_verbosity = 1
}

// We're gonna diverge from original Java here and force a dependency injection
// Of the Minecraft ptr instead of storing it as a field,
// because Odin forbids cyclical declarations like that.
Options_init :: proc(this: ^Options, mc_inst: ^Minecraft, f: j_io.File)
{
	// Set defaults
	this^ = Options_DEFAULT

	j_io.File_open(&this.options_file, "options.txt")
	is64 := Minecraft_is_64bit(mc_inst)

	/*OptionInstance_init(&this.render_distance,
		"options.render_distance")*/
}

// @Static
Options_generic_value_label_comp :: proc(c1, c2: ^Component) -> (^Component)
{
	return Component_translatable("options.generic_value", transmute([]rawptr) []^Component{ c1, c2 })
}

// @Static
Options_generic_value_label_int :: proc(c: ^Component, i: int) -> (^Component)
{
	return Options_generic_value_label_comp(c, Component_literal(j_misc.int_to_string(i)))
}

// @Static
Options_generic_value_label :: proc{
	Options_generic_value_label_comp,
	Options_generic_value_label_int,
}

// @LingeringAlloc (x2)
// @Static
Options_percent_value_label :: proc(c: ^Component, d: f64) -> (^Component)
{
	combined := make([]rawptr, 2)

	combined[0] = (rawptr)(c)
	n := new(int)
	n^ = int(d * f64(100.0))
	combined[1] = (rawptr)(n)

	return Component_translatable("options.percent_value", combined)
}