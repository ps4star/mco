package opengl

import ogl "vendor:OpenGL"

GL20_glAttachShader :: proc(i1, i2: u32)
{
	ogl.AttachShader(i1, i2)
}

GL20_glDeleteShader :: proc(i1: u32)
{
	ogl.DeleteShader(i1)
}