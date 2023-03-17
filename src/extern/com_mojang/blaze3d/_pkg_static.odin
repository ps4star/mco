package cm_blaze3d

INIT :: #force_inline proc()
{
	RenderSystem_INIT()
	Tesselator_INIT()
	GlStateManager_INIT()
	Lighting_INIT()
	Program_Type_INIT()
}