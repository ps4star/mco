package cm_blaze3d
import "core:fmt"
import "core:slice"
// import "core:runtime"
// import "core:mem"

import glfw "shared:OdinGLFW"

MonitorHandle :: glfw.MonitorHandle
Monitor :: struct
{
	monitor: MonitorHandle,
	video_modes: [dynamic]VideoMode,
	current_mode: VideoMode,
	x, y: i32, // c.int
}

Monitor_init :: proc(this: ^Monitor, l: MonitorHandle)
{
	this.monitor = l
	this.video_modes = make(type_of(this.video_modes))
	Monitor_refresh_video_modes(this)
}

Monitor_refresh_video_modes :: proc(this: ^Monitor)
{
	/*
	// RenderSystem.assertInInitPhase();
    // this.videoModes.clear();
    GLFWVidMode.Buffer buffer = GLFW.glfwGetVideoModes(this.monitor);

      for(int i = buffer.limit() - 1; i >= 0; --i) {
         buffer.position(i);
         VideoMode videomode = new VideoMode(buffer);
         if (videomode.getRedBits() >= 8 && videomode.getGreenBits() >= 8 && videomode.getBlueBits() >= 8) {
            this.videoModes.add(videomode);
         }
      }

   int[] aint = new int[1];
   int[] aint1 = new int[1];
   GLFW.glfwGetMonitorPos(this.monitor, aint, aint1);
   this.x = aint[0];
   this.y = aint1[0];
   GLFWVidMode glfwvidmode = GLFW.glfwGetVideoMode(this.monitor);
   this.currentMode = new VideoMode(glfwvidmode);*/

	RenderSystem_assert_in_init_phase()
	clear(&(this.video_modes))

	v_modes := glfw.GetVideoModes(this.monitor)
	for i := len(v_modes) - 1; i >= 0; i -= 1 {
		this_vm := &(v_modes[i])
		if this_vm.red_bits >= 8 && this_vm.green_bits >= 8 && this_vm.blue_bits >= 8 {
			append(&(this.video_modes), v_modes[i])
		}
	}

	this.x, this.y = glfw.GetMonitorPos(this.monitor)
	this.current_mode = glfw.GetVideoMode(this.monitor)^
}

Monitor_get_preferred_vid_mode :: proc(this: ^Monitor, v: Maybe(VideoMode)) -> (VideoMode)
{
	RenderSystem_assert_in_init_phase()
	v := v
	if v != nil
	{
		vm := &(v.?)
		for _, i in this.video_modes
		{
			if VideoMode_equals(&this.video_modes[i], vm)
			{
				return this.video_modes[i]
			}
		}
	}

	return this.current_mode
}

Monitor_get_current_mode :: #force_inline proc(this: ^Monitor) -> (VideoMode)
{
	return this.current_mode
}