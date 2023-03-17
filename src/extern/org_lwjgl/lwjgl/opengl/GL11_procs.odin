package opengl
import "core:fmt"
import "core:strings"
import "core:slice"

import ogl				"vendor:OpenGL"
//import oglfw			"shared:OdinGLFW"

import "mco:odin/global"

when ODIN_OS == .Linux {
	foreign import lib "system:GLX"

	foreign lib {
		@(private="file")
		glXGetProcAddress :: proc(str: cstring) -> (rawptr) ---
	}

	get_proc_addr :: glXGetProcAddress
} else when ODIN_OS == .Windows {
	foreign import lib "system:WGL"

	foreign lib {
		@(private="file")
		wglGetProcAddress :: proc(str: cstring) -> (rawptr) ---
	}

	get_proc_addr :: wglGetProcAddress
}

/* NOTE
GL11C is ommitted since it's just an extra wrapper we don't need.
Instead, we can simply have the external interface take 
*/

// CUSTOM/INIT
// Odin OpenGL requires load_up_to to be called.
GL11_INIT :: proc()
{
	// I'm not sure what OpenGL version the java code relies on
	// I know that it's >=1.1 at least but not sure about the specific ver.
	// Should probably TODO: find that out

	// DO NOTHING on macOS because apparently all GL functions are auto-linked there
	when ODIN_OS != .Darwin {
		ogl.load_up_to(3, 1, proc(p: rawptr, str: cstring) {
			(cast(^rawptr)p)^ = get_proc_addr(str)
		})
	}
}

// METHODS
GL11_new :: #force_inline proc()
{
	global.throw_unchecked({ .UnsupportedOperationException }, "GL11 does not have a constructor, why are you trying to call it?")
}

GL11_glEnable :: proc(target: int)
{
	ogl.Enable(u32(target))
}

GL11_glDisable :: proc(target: int)
{
	ogl.Disable(u32(target))
}

GL11_glClear :: proc(mask: u32)
{
	ogl.Clear(mask)
}

GL11_glGetError :: proc() -> (u32)
{
	return ogl.GetError()
}

GL11_glGetString :: proc(name: u32) -> (cstring)
{
	return ogl.GetString(name)
}

GL11_glGenTextures_single :: proc() -> ([]u32)
{
	out_tex := make([]u32, 1)
	as_p, worked := slice.get_ptr(out_tex, 0)
	assert(worked)

	ogl.GenTextures(1, transmute([^]u32) as_p)
	return out_tex
}
GL11_glGenTextures_multi :: proc(arr: []u32)
{
	as_p, worked := slice.get_ptr(arr, 0)
	assert(worked)

	ogl.GenTextures(cast(i32) len(arr), transmute([^]u32) as_p)
}
GL11_glGenTextures :: proc{
	GL11_glGenTextures_single,
	GL11_glGenTextures_multi,
}

GL11_glGetInteger :: proc(i: u32) -> (i32)
{
	out: i32 = 0
	ogl.GetIntegerv(i, &out)
	return out
}

GL11_glGetTexLevelParameteri :: proc(targ: u32, level: i32, pname: u32) -> (i32)
{
	temp: i32
	ogl.GetTexLevelParameteriv(targ, level, pname, &temp)
	return temp
}

GL11_glTexImage2D :: proc(targ: u32,
	level: i32,
	internal_fmt: i32,
	width: i32,
	height: i32,
	border: i32,
	fmt: u32,
	type: u32,
	data: rawptr)
{
	ogl.TexImage2D(targ, level, internal_fmt, width, height, border, fmt, type, data)
}

GL11_glBindTexture :: proc(targ, tex: u32)
{
	ogl.BindTexture(targ, tex)
}

GL11_glClearDepth :: proc(f: f64)
{
	ogl.ClearDepth(f)
}

GL11_glDepthFunc :: proc(i: u32)
{
	ogl.DepthFunc(i)
}

GL11_glViewport :: proc(i1, i2, i3, i4: i32)
{
	ogl.Viewport(i1, i2, i3, i4)
}

GL11_glClearColor :: proc(r, g, b, a: f32)
{
	ogl.ClearColor(r, g, b, a)
}