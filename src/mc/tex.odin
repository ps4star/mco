package mc

import "mco:odin/global"
import "mco:extern/com_mojang/logging"
import j_util "mco:java/util"

@(private="file")
glog := &logging.g_logger

TextureManager_INTENTIONAL_MISSING_TEX: ResourceLocation
TextureManager :: struct
{
	by_path: map[^ResourceLocation]^AbstractTexture,
	tickable_textures: j_util.Set(global.GENERIC),
	prefix_register: map[string]int,
	rmgr: ResourceManager,
}

TextureManager_INIT :: proc()
{
	TextureManager_INTENTIONAL_MISSING_TEX = ResourceLocation_new("")
}

TextureManager_new :: #force_inline proc(rmgr: ResourceManager) -> (this: TextureManager)
{
	this.rmgr = rmgr
	return this
}

TextureManager_bind_for_setup :: proc(this: ^TextureManager)
{
	// IMPL
}





LightTexture :: struct
{

}

LightTexture_init :: proc(this: ^LightTexture, gren: ^GameRenderer, minecraft: ^Minecraft)
{
	
}