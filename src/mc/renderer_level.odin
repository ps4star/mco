package mc

LevelRenderer :: struct
{
	needs_full_render_chunk_update: bool,
	generate_clouds: bool,
}

LevelRenderer_needs_update :: proc(this: ^LevelRenderer)
{
	this.needs_full_render_chunk_update = true
	this.generate_clouds = true
}