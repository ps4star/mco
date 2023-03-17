package mc

Style :: struct
{
	color: Maybe(TextColor),
	bold: Maybe(bool),
	italic: Maybe(bool),
	underlined: Maybe(bool),
	strikethrough: Maybe(bool),
	obfuscated: Maybe(bool),
	click_event: Maybe(ClickEvent),
	hover_event: Maybe(HoverEvent),
	insertion: Maybe(string),
	font: Maybe(ResourceLocation),
}

Style_DEFAULT_FONT: ResourceLocation
Style_EMPTY: Style
Style_INIT :: proc()
{
	Style_DEFAULT_FONT = ResourceLocation_new("minecraft", "default")
}

Style_get_font :: proc(this: ^Style) -> (ResourceLocation)
{
	return this.font.? if this.font != nil else Style_DEFAULT_FONT
}