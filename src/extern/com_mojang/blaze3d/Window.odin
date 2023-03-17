package cm_blaze3d
import "core:fmt"
import "core:strings"

import global "mco:odin/global"
import conf "mco:odin/conf"

import logging "mco:extern/com_mojang/logging"

import glfw "shared:OdinGLFW"
import gl "vendor:OpenGL"

// EVENT
// @SubInterface
WindowEventHandler :: struct
{
	set_window_active: proc(rawptr, bool),
	resize_display: proc(rawptr),
	cursor_entered: proc(rawptr),
}



WindowHandle :: glfw.WindowHandle
Window :: struct
{
	event_handler: WindowEventHandler,

	error_section: string,
	glfw_win_hnd: WindowHandle,

	windowed_x, windowed_y, windowed_width, windowed_height: int,
	preferred_fullscreen_video_mode: Maybe(VideoMode),

	fullscreen, actually_fullscreen: bool,
	x, y, width, height: int,

	gui_scale: f64,
	frame_buffer_width, frame_buffer_height: int,
	gui_scaled_width, gui_scaled_height: int,

	dirty: bool,
	framerate_limit: int,
	vsync: bool,

	smgr: ScreenManager,
}

Window_init :: proc(this: ^Window, event_handler: ^WindowEventHandler, smgr: ^ScreenManager, disp_d: ^DisplayData, s: string, s2: string)
{
	this.error_section = ""
	this.smgr = smgr^
	Window_set_boot_error_callback(this)
	Window_set_error_section(this, "Pre startup")
	this.event_handler = event_handler^

	// IMPL
	vm := VideoMode_read(s)
	if vm != nil
	{
		this.preferred_fullscreen_video_mode = vm
	} else if disp_d.fs_width != nil && disp_d.fs_height != nil
	{
		this.preferred_fullscreen_video_mode = cast(Maybe(VideoMode)) VideoMode{
			i32(disp_d.fs_width.?), i32(disp_d.fs_height.?),
			8, 8, 8,
			60,
		}
	} else
	{
		this.preferred_fullscreen_video_mode = nil
	}

	this.fullscreen = disp_d.is_fullscreen
	this.actually_fullscreen = this.fullscreen

	mon := ScreenManager_get_monitor(smgr, glfw.GetPrimaryMonitor())
	this.width = disp_d.width if disp_d.width > 0 else 1
	this.windowed_width = this.width

	this.height = disp_d.height if disp_d.height > 0 else 1
	this.windowed_height = this.height

	glfw.WindowHint(139265, 196609)
	glfw.WindowHint(139275, 221185)
	glfw.WindowHint(139266, 3)
	glfw.WindowHint(139267, 2)
	glfw.WindowHint(139272, 204801)
	glfw.WindowHint(139270, 1)

	this.glfw_win_hnd = glfw.CreateWindow(i32(this.width), i32(this.height),
		strings.clone_to_cstring(s2, context.temp_allocator),
		mon.monitor if (this.fullscreen && mon != nil) else glfw.MonitorHandle(nil),
		glfw.WindowHandle(nil))

	if mon != nil
	{
		video_mode := Monitor_get_preferred_vid_mode(mon, this.preferred_fullscreen_video_mode if this.fullscreen else nil)
		this.x = int(mon.x) + int(video_mode.width / 2) - (this.width / 2)
		this.windowed_x = this.x

		this.y = int(mon.y) + int(video_mode.height / 2) - this.height / 2
		this.windowed_y = this.y
	} else
	{
		aint1, aint := glfw.GetWindowPos(this.glfw_win_hnd)
		this.x = int(aint1)
		this.windowed_x = this.x

		this.y = int(aint)
		this.windowed_y = this.y
	}

	glfw.MakeContextCurrent(this.glfw_win_hnd)
	// gl.load_up_to(3, 1, glfw.gl_set_proc_address)
	Window_set_mode(this)
	Window_refresh_frame_buffer_size(this)
}

Window_set_boot_error_callback :: proc(this: ^Window)
{
	RenderSystem_assert_in_init_phase()
	glfw.SetErrorCallback(Window_boot_crash)
}

// @Static
Window_boot_crash :: proc "c" (i: i32, desc: cstring)
{
	context = global.custom_context

	RenderSystem_assert_in_init_phase()
	global.throw_unchecked({ .Exception }, "GLFW error occurred.")
}

Window_should_close :: #force_inline proc(this: ^Window) -> (bool)
{
	return cast(bool) glfw.WindowShouldClose(this.glfw_win_hnd)
}

Window_set_error_section :: #force_inline proc(this: ^Window, s: string)
{
	this.error_section = s
}

Window_set_mode :: proc(this: ^Window)
{
	// IMPL
	RenderSystem_assert_in_init_phase()
	flag := glfw.GetWindowMonitor(this.glfw_win_hnd) != nil
	if this.fullscreen
	{
		monitor := ScreenManager_find_best_monitor(&this.smgr, this)
		if monitor == nil
		{
			logging.log(.Warn, "Failed to find good monitor for fullscreen.")
			this.fullscreen = false
		} else
		{
			when ODIN_OS == .Darwin
			{
				// MacOS toggle fullscreen
			}

			vm := Monitor_get_preferred_vid_mode(monitor, this.preferred_fullscreen_video_mode)
			if !flag
			{
				this.windowed_x = this.x
				this.windowed_y = this.y
				this.windowed_width = this.width
				this.windowed_height = this.height
			}

			this.x = 0
			this.y = 0
			this.width = cast(int) vm.width
			this.height = cast(int) vm.height
			glfw.SetWindowMonitor(this.glfw_win_hnd, monitor.monitor, i32(this.x), i32(this.y), i32(this.width), i32(this.height), vm.refresh_rate)
		}
	} else
	{
		this.x = this.windowed_x
		this.y = this.windowed_y
		this.width = this.windowed_width
		this.height = this.windowed_height

		glfw.SetWindowMonitor(this.glfw_win_hnd, nil, i32(this.x), i32(this.y), i32(this.width), i32(this.height), -1)
	}
}

Window_set_framerate_limit :: #force_inline proc(this: ^Window, limit: int)
{
	this.framerate_limit = limit
}

Window_toggle_fullscreen :: proc(this: ^Window)
{
	this.fullscreen = !this.fullscreen
}

Window_refresh_frame_buffer_size :: proc(ths: ^Window)
{
	// IMPL
}

// @FullyImplemented
// @ShouldVerifyParity
Window_set_gui_scale :: proc(this: ^Window, new_scale: f64)
{
	this.gui_scale = new_scale
	i := int(f64(this.frame_buffer_width) / new_scale)
	this.gui_scaled_width = (i + 1) if ((f64(this.frame_buffer_width) / new_scale) > f64(i)) else i

	j := int(f64(this.frame_buffer_height) / new_scale)
	this.gui_scaled_height = (j + 1) if ((f64(this.frame_buffer_height) / new_scale) > f64(j)) else j
}

// @FullyImplemented
// @ShouldVerifyParity
Window_calculate_scale :: proc(this: ^Window, scale_int: int, force_even: bool) -> (int)
{
	i: int
	for i = 1; i != scale_int &&
		i < this.frame_buffer_width &&
		i < this.frame_buffer_height &&
		this.frame_buffer_width / (i + 1) >= 320 &&
		this.frame_buffer_height / (i + 1) >= 240; i += 1 {} // NOP; calculation loop

	if force_even && i % 2 != 0 {
		i += 1
	}
	return i
}

Window_set_title :: proc(this: ^Window, t: string)
{
	as_cstr := strings.clone_to_cstring(t, context.temp_allocator)
	glfw.SetWindowTitle(this.glfw_win_hnd, as_cstr)
}

// @Static
Window_check_glfw_error :: proc(cb: proc(i32, string))
{
	RenderSystem_assert_in_init_phase()

	desc, err := glfw.GetError()
	if err != 0 {
		cb(err, desc)
	}
}

Window_update_display :: proc(this: ^Window)
{
	RenderSystem_flip_frame(this.glfw_win_hnd)
	if this.fullscreen != this.actually_fullscreen
	{
		this.actually_fullscreen = this.fullscreen
		Window_update_fullscreen(this, this.vsync)
	}
}

Window_update_fullscreen :: proc(this: ^Window, vsync: bool)
{
	RenderSystem_assert_on_render_thread()

	Window_set_mode(this)
	// this.eventHandler.resizeDisplay()
	Window_update_vsync(this, vsync)
	Window_update_display(this)
}

Window_update_vsync :: proc(this: ^Window, vsync: bool)
{

}