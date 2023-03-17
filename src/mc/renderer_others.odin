package mc

MapRenderer :: struct
{
	tex_mgr: ^TextureManager,
}

MapRenderer_init :: proc(this: ^MapRenderer, tex_mgr: ^TextureManager)
{
	this.tex_mgr = tex_mgr
}