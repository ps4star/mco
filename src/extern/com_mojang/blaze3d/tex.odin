package cm_blaze3d

TexUtil_gen_tex_id :: proc() -> (u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	if false // SharedConstants.IS_RUNNING_IN_IDE
	{
		// IMPL
		panic("Unimpl")
	} else
	{
		return GlStateManager_glGenTextures()[0]
	}
}