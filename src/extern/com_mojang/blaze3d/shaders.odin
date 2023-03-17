package cm_blaze3d





Shader :: struct
{
	get_id: proc(rawptr) -> (int),
	mark_dirty: proc(rawptr),
	get_vertex_program: proc(rawptr) -> (^Program),
	get_fragment_program: proc(rawptr) -> (^Program),
	attach_to_program: proc(rawptr),
}




ProgID :: int
Program :: struct
{
	type: Program_Type,
	name: string,
	id: ProgID,
}

Program_get_id :: #force_inline proc(this: ^Program) -> (ProgID)
{
	return this.id
}

Program_attach_to_shader :: proc(this: ^Program, shad: ^Shader)
{
	RenderSystem_assert_on_render_thread()
	GlStateManager_glAttachShader(cast(u32) shad->get_id(), cast(u32) Program_get_id(this)) // NOTE: unhandled == -1 cases
}

Program_close :: proc(this: ^Program)
{
	if this.id != -1
	{
		RenderSystem_assert_on_render_thread()
		GlStateManager_glDeleteShader(cast(u32) this.id) // NOTE: unhandled == -1 cases
		this.id = -1
	}
}





Program_Type :: enum
{
	Vertex,
	Fragment,
}

Program_TypeValue :: struct
{
	name: string,
	extension: string,
	gl_type: u32,
	programs: map[string]Program,
}

Program_TypeValues := [Program_Type]Program_TypeValue{
	.Vertex = { name = "vertex", extension = ".vsh", gl_type = 35_633 },
	.Fragment = { name = "fragment", extension = ".fsh", gl_type = 35_632 },
}

Program_Type_INIT :: proc()
{
	for _, i in Program_TypeValues
	{
		Program_TypeValues[i].programs = make(type_of(Program_TypeValues[i].programs))
	}
}

Program_Type_get :: proc(which: Program_Type) -> (^Program_TypeValue)
{
	return &(Program_TypeValues[which])
}

Program_Type_init :: proc(this: ^Program_TypeValue, name, extension: string, gl_type: u32)
{
	this.name = name
	this.extension = extension
	this.gl_type = gl_type

	this.programs = make(type_of(this.programs))
}

Program_Type_get_programs :: #force_inline proc(which: Program_Type) -> (^map[string]Program)
{
	return &(Program_TypeValues[which].programs)
}