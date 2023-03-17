package opengl
import "core:fmt"
import "core:strings"

import ogl "vendor:OpenGL"

// TODO: (MAYBE) make the outward interface already take the GL types (like u32 vs. int)
// there might be bugs with taking unspecified-width types here, but idk yet at this stage

// Procs for GL30
GL30_glBindVertexArray :: proc(array: int)
{
	ogl.impl_BindVertexArray(u32(array))
}

GL30_glBindFramebuffer :: proc(targ, fbuf: u32)
{
	ogl.BindFramebuffer(targ, fbuf)
}