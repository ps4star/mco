package opengl
import "core:fmt"
import "core:strings"
import "core:slice"

import ogl				"vendor:OpenGL"
//import oglfw			"shared:OdinGLFW"

import "mco:odin/global"

GL14_glBlendFuncSeparate :: proc(i1, i2, i3, i4: u32)
{
	ogl.BlendFuncSeparate(i1, i2, i3, i4)
}