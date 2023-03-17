package mc

WidthProviderProc :: #type proc(rawptr, int, ^Style) -> (f32)
StringSplitter :: struct
{
	wp: WidthProviderProc,
}

StringSplitter_init :: proc(this: ^StringSplitter, wp: WidthProviderProc)
{
	this.wp = wp
}