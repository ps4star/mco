// @AllStatic
package cm_blaze3d
import "core:fmt"
import "core:strings"
import "core:runtime"
import global "mco:odin/global"

import j_func "mco:java/util/function"

import "mco:extern/com_mojang/logging"

import glfw "shared:OdinGLFW"

@private
err_list: [dynamic]string // @TAlloc; @InternalProcUse

// @Static
// @UsesImplicitContext
// @TAlloc (expect ~400 bytes, idk)
GLX_init_glfw :: proc "odin" () -> (j_func.LongSupplier)
{
	RenderSystem_assert_in_init_phase()
	Window_check_glfw_error(proc(i: i32, s: string)
	{
		global.throw_unchecked({ .IllegalStateException }, fmt.tprintln("GLFW error before init: ", i, s))
	})

	err_list = make(type_of(err_list), context.temp_allocator) // don't delete(); is talloced
	glfw_ec := glfw.SetErrorCallback(proc "c" (err: i32, description: cstring)
	{
		context = runtime.default_context()
		append(&err_list, fmt.tprintln("GLFW error during init:", err, description))
	})

	if !bool(glfw.Init()) {
		global.throw_unchecked({ .IllegalStateException },
			fmt.tprintln("Failed to initialize GLFW, errors:",
				strings.join(err_list[:], ",", context.temp_allocator)))
		return { get = nil }
	}

	lsup := j_func.LongSupplier{
		get = proc(_: rawptr) -> (i64)
		{
			return cast(i64) (glfw.GetTime() * f64(1.0e9))
		}
	}

	for s in err_list {
		logging.log(.Error, fmt.tprintln("GLFW error during init:", s))
	}

	RenderSystem_assert_in_init_phase()
	//RenderSystem_set_error_callback(glfw_ec)
	return lsup
}

// @Static
GLX_set_glfw_error_callback :: proc(cb: glfw.ErrorProc)
{
	RenderSystem_assert_in_init_phase()
	/*glfw_err_cb :=*/ glfw.SetErrorCallback(cb)

	/*if glfw_err_cb != nil {
		free(glfw_err_cb) // ??? not really sure why this is here but it shouldn't cause issues
	}*/
}

// @Static
GLX_should_close :: #force_inline proc(win: ^Window) -> (bool) // this is just the same thing as Window_should_close() ??? why is this here
{
	return cast(bool) glfw.WindowShouldClose(win.glfw_win_hnd)
}

// @Static
GLX_render_crosshair :: proc()
{
	RenderSystem_assert_on_render_thread()

}

// @Static
GLX_init :: proc(i: int, b: bool)
{
	RenderSystem_assert_in_init_phase()

	// Some CPU info get code, not really necessary and too complicated to impl imo

	GlDebug_enable_debug_callback(i, b)
}

// @Static
GLX_get_opengl_version_string :: proc() -> (string)
{
	RenderSystem_assert_on_render_thread()
	return "NO CONTEXT" if glfw.GetCurrentContext() == nil else strings.concatenate({
		strings.clone_from_cstring(GlStateManager_glGetString(7937), context.temp_allocator),
		" GL version ",
		strings.clone_from_cstring(GlStateManager_glGetString(7938), context.temp_allocator),
		", ",
		strings.clone_from_cstring(GlStateManager_glGetString(7936), context.temp_allocator),
	})
}