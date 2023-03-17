package mc
import "mco:odin/global"
import "mco:odin/conf"

ENCHANT_GLINT_LOCATION: ResourceLocation
ItemRenderer :: struct
{
	blit_offset: f32,
}

ItemRenderer_INIT :: proc()
{
	ENCHANT_GLINT_LOCATION = ResourceLocation_new("textures/misc/enchanted_item_glint.png")
}



ItemInHandRenderer :: struct
{

}

