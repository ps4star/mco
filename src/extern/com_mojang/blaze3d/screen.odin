package cm_blaze3d
import "core:fmt"
import "core:runtime"

import logging "mco:extern/com_mojang/logging"

import glfw "shared:OdinGLFW"

ScreenManager :: struct
{
	monitors: map[glfw.MonitorHandle]Monitor,
}

ScreenManager_init :: proc(this: ^ScreenManager)
{
	/*
	// RenderSystem.assertInInitPhase();
    // this.monitorCreator = p_85265_;
      GLFW.glfwSetMonitorCallback(this::onMonitorChange);
      PointerBuffer pointerbuffer = GLFW.glfwGetMonitors();
      if (pointerbuffer != null) {
         for(int i = 0; i < pointerbuffer.limit(); ++i) {
            long j = pointerbuffer.get(i);
            this.monitors.put(j, p_85265_.createMonitor(j));
         }
   }*/

	RenderSystem_assert_in_init_phase()
	glfw.SetMonitorCallback(ScreenManager_on_monitor_change)
	// glfw.SetMonitorUserPointer(/*  */, (rawptr)(this))

	monitors := glfw.GetMonitors()
	if len(monitors) > 0 {
		for m, i in monitors {
			this.monitors[m] = Monitor{}
			Monitor_init(&(this.monitors[m]), m) // !!! SEGFAULT

			/*
				In the Java, GLFW/LWJGL does something (idk) to allow the "this" to be passed through to
				GLFW callbacks.

				Using Odin's context here would be impossible since we can't control the CB *calls*, only the defs.
				I don't think setting context in def scope works either, it only matters for call scope as far as I know.

				Luckily GLFW does provide a user pointer for these callbacks, so we just set that here.
				This really should be tested thoroughly as this function doesn't seem to be called at all
				in the Java and again I'm really not sure how they're managing to pass it, maybe through
				some weird reflection stuff idk.
			*/
			glfw.SetMonitorUserPointer(m, (rawptr)(this))
		}
	}
}

// @FullyImplemented
// @NotVerifiedParity (glfw)
ScreenManager_on_monitor_change :: proc "c" (/*this: ^ScreenManager, */m_hnd: glfw.MonitorHandle, evt: i32)
{
	context = runtime.default_context()
	this := (^ScreenManager)(glfw.GetMonitorUserPointer(m_hnd))

	RenderSystem_assert_on_render_thread()
	if evt == glfw.CONNECTED {
		this.monitors[m_hnd] = Monitor{}
		Monitor_init(&(this.monitors[m_hnd]), m_hnd)
		// LOGGER.debug("Monitor {} connected. Current monitors: {}", p_85274_, this.monitors);
		logging.log(.Debug, fmt.aprintln("Monitor:", this.monitors[m_hnd], "connected.\n\nCurrent:", this.monitors))
	} else if evt == glfw.DISCONNECTED {
		delete_key(&(this.monitors), m_hnd)
		logging.log(.Debug, fmt.aprintln("Monitor:", this.monitors[m_hnd], "disconnected.\n\nCurrent:", this.monitors))
	}
}

ScreenManager_get_monitor :: proc(this: ^ScreenManager, hnd: glfw.MonitorHandle) -> (^Monitor)
{
	RenderSystem_assert_in_init_phase()
	return &this.monitors[hnd]
}

ScreenManager_find_best_monitor :: proc(this: ^ScreenManager, win: ^Window) -> (^Monitor)
{
	i := glfw.GetWindowMonitor(win.glfw_win_hnd)
	if i != nil
	{
		return ScreenManager_get_monitor(this, i)
	}

	j := win.x
	k := j + win.width
	l := win.y
	i1 := l + win.height
	j1 := -1

	monitor := (^Monitor)(nil)
	k1 := glfw.GetPrimaryMonitor()
	logging.log(.Debug, fmt.tprintln("Selecting primary monitor - primary:", k1, "current:", this.monitors))

	for _k, v in &(this.monitors)
	{
		l1 := v.x
		i2 := l1 + (Monitor_get_current_mode(&v).width)
		j2 := v.y
		k2 := j2 + (Monitor_get_current_mode(&v).height)
		l2 := clamp(i32(j), l1, i2)
		i3 := clamp(i32(k), l1, i2)
		j3 := clamp(i32(l), j2, k2)
		k3 := clamp(i32(i1), j2, k2)
		l3 := max(0, i3 - l2)
		i4 := max(0, k3 - j3)
		j4 := l3 * i4

		if j4 > i32(j1)
		{
			monitor = &v
			j1 = int(j4)
		} else if j4 == i32(j1) && k1 == v.monitor
		{
			logging.log(.Debug, "Primary monitor is preferred to other.")
			monitor = &v
		}
	}

	logging.log(.Debug, fmt.tprintln("Selected monitor:", monitor))
	return monitor
}