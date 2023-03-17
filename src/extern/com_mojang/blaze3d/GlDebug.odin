package cm_blaze3d

GlDebug_enable_debug_callback :: proc(i: int, b: bool)
{
	RenderSystem_assert_in_init_phase()
	if i > 0
	{
		/*GLCapabilities glcapabilities = GL.getCapabilities();
         if (glcapabilities.GL_KHR_debug) {
            debugEnabled = true;
            GL11.glEnable(37600);
            if (p_84051_) {
               GL11.glEnable(33346);
            }

            for(int i = 0; i < DEBUG_LEVELS.size(); ++i) {
               boolean flag = i < p_84050_;
               KHRDebug.glDebugMessageControl(4352, 4352, DEBUG_LEVELS.get(i), (int[])null, flag);
            }

            KHRDebug.glDebugMessageCallback(GLX.make(GLDebugMessageCallback.create(GlDebug::printDebugLog), DebugMemoryUntracker::untrack), 0L);
         } else if (glcapabilities.GL_ARB_debug_output) {
            debugEnabled = true;
            if (p_84051_) {
               GL11.glEnable(33346);
            }

            for(int j = 0; j < DEBUG_LEVELS_ARB.size(); ++j) {
               boolean flag1 = j < p_84050_;
               ARBDebugOutput.glDebugMessageControlARB(4352, 4352, DEBUG_LEVELS_ARB.get(j), (int[])null, flag1);
            }

            ARBDebugOutput.glDebugMessageCallbackARB(GLX.make(GLDebugMessageARBCallback.create(GlDebug::printDebugLog), DebugMemoryUntracker::untrack), 0L);
        }*/

        
	}
}