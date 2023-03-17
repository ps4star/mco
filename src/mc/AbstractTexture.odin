package mc

AbstractTexture_NOT_ASSIGNED :: -1
AbstractTexture :: struct {
	id: int,
	blur: bool,
	mipmap: bool,
}

AbstractTexture_set_filter :: proc(this: ^AbstractTexture, blur, mipmap: bool)
{
	
}