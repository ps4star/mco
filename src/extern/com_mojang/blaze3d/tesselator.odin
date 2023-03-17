package cm_blaze3d

@private
INST: ^Tesselator

Tesselator :: struct
{
	builder: BufferBuilder,
}

Tesselator_INIT :: proc()
{
	INST = new(Tesselator)
	Tesselator_init(INST)
}

Tesselator_get_instance :: proc() -> (^Tesselator)
{
	RenderSystem_assert_on_game_thread_or_init()
	return INST
}

Tesselator_init_int :: proc(this: ^Tesselator, i: int)
{
	BufferBuilder_init(&this.builder, i)
}
Tesselator_init_none :: proc(this: ^Tesselator)
{
	Tesselator_init_int(this, 2097152)
}
Tesselator_init :: proc{
	Tesselator_init_int,
	Tesselator_init_none,
}

/*Tesselator_end :: proc(this: ^Tesselator)
{
	BufferUploader_draw_with_shader(BufferBuilder_end(&this.builder))
}*/