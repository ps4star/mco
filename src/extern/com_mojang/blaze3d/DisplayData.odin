package cm_blaze3d

DisplayData :: struct
{
	width: int,
	height: int,
	fs_width: Maybe(int),
	fs_height: Maybe(int),
	is_fullscreen: bool,
}

/*DisplayData_new :: proc(width, height, fwidth, fheight: int, isf: bool) -> (out: DisplayData)
{
	out.width = width
	out.height = height
	out.fullscreenWidth = fwidth
	out.fullscreenHeight = fheight
	out.isFullscreen = isf
	return
}*/