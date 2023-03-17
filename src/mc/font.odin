package mc

import j_misc "mco:java/misc"

import blaze "mco:extern/com_mojang/blaze3d"

Font :: struct
{
	fonts: proc(rawptr, ResourceLocation) -> (^FontSet),
	splitter: StringSplitter,
}

ResToFontSetProc :: #type proc(rawptr, ResourceLocation) -> (^FontSet)
Font_init :: proc(this: ^Font, fonts: ResToFontSetProc)
{
	this.fonts = fonts
	StringSplitter_init(&(this.splitter), proc(_this: rawptr, i: int, s: ^Style) -> (f32)
	{
		this := (^Font)(_this)
		f_set := Font_get_font_set(this, Style_get_font(s))
		glyph_info := FontSet_get_glyph_info(f_set, i)
		return 0.0
	})
}

Font_get_font_set :: proc(this: ^Font, res_loc: ResourceLocation) -> (^FontSet)
{
	return this.fonts(this, res_loc)
}

FontSet :: struct
{
	tex_mgr: ^TextureManager,
	name: ResourceLocation,
	missing_glyph: blaze.BakedGlyph,
	white_glyph: blaze.BakedGlyph,
	providers: [dynamic]blaze.GlyphProvider,
}

// IMPL
FontSet_get_glyph_info :: proc(this: ^FontSet, i: int) -> (^blaze.GlyphInfo)
{
	return nil
}


FontLocationMap :: map[ResourceLocation]ResourceLocation
FontResourceMap :: map[ResourceLocation]^FontSet
FontManager :: struct
{
	font_sets: FontResourceMap,
	renames: FontLocationMap,
	missing_font_set: FontSet,
	tex_mgr: ^TextureManager,
}

FontManager_set_renames :: proc(this: ^FontManager, res_map: FontLocationMap)
{
	this.renames = res_map
}

FontManager_create_font :: proc(this: ^FontManager) -> (out: Font)
{
	Font_init(&out, proc(_this: rawptr, res: ResourceLocation) -> (^FontSet)
	{
		this := (^FontManager)(_this)
		return j_misc.Map_get_or_default(this.font_sets, j_misc.Map_get_or_default(this.renames, res, res), &(this.missing_font_set))
	})
	return
}