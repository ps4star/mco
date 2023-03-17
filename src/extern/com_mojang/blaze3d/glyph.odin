package cm_blaze3d

SheetGlyphInfo :: struct
{

}

BakedGlyph :: struct
{
	
}

GlyphInfo :: struct
{
	get_adv: proc(rawptr) -> (f32),
	get_adv_bool: proc(rawptr, bool) -> (f32), // @HasDefault
	bold_off, shadow_off: f32,
	bake: proc(rawptr, proc(SheetGlyphInfo) -> (BakedGlyph)) -> (BakedGlyph),
}

GlyphInfo_init :: proc(this: ^GlyphInfo)
{
	this.get_adv_bool = proc(_this: rawptr, b: bool) -> (f32)
	{
		this := (^GlyphInfo)(_this)
		return this->get_adv() + (this.bold_off if b else 0.0)
	}

	this.bold_off = 1.0
	this.shadow_off = 1.0
}




GlyphProvider :: struct
{
	close: proc(rawptr),
	get_glyph: proc(rawptr, int) -> (^GlyphInfo),
	get_supported_glyphs: proc(rawptr) -> ([]int),
}

GlyphProvider_init :: proc(this: ^GlyphProvider)
{
	this.close = proc(_: rawptr) {}
	this.get_glyph = proc(this: rawptr, i: int) -> (^GlyphInfo) { return nil }
}