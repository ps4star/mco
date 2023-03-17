package cm_blaze3d
import "core:fmt"
import "core:strings"

import "mco:odin/global"

import "mco:extern/com_mojang/logging"
import cm_math "mco:extern/com_mojang/math"

import j_lang "mco:java/lang"
import j_func "mco:java/util/function"
import j_concur "mco:java/util/concurrent"
import j_util "mco:java/util"

import glfw "shared:OdinGLFW"

import mc_common "mco:mc/common"

RenderCallProc :: #type proc(_this: rawptr)
RenderCall :: struct
{
	ctx: rawptr,
	execute: RenderCallProc,
}

@(private="file")
glog := &logging.g_logger

@(private="file")
is_in_init: bool

@(private="file")
recording_queue: j_concur.ConcurrentLinkedQueue(RenderCall)

@(private="file")
shader_light_directions: []cm_math.Vector3f

// Matrices
inverse_view_rotation_matrix := matrix[3, 3]f32{}
projection_matrix := matrix[4, 4]f32{}
saved_projection_matrix := matrix[4, 4]f32{}
model_view_stack: PoseStack
model_view_matrix := matrix[4, 4]f32{}
texture_matrix := matrix[4, 4]f32{}

RenderSystem_render_thread: ^j_lang.Thread
RenderSystem_game_thread: ^j_lang.Thread

RENDER_THREAD_TESSELATOR: ^Tesselator

is_replaying_queue: bool = false

@(private="file")
api_desc: string = "Unknown"

MAX_SUPPORTED_TEX_SIZE: int = -1

RenderSystem_INIT :: proc()
{
	RENDER_THREAD_TESSELATOR = new(Tesselator)
	Tesselator_init(RENDER_THREAD_TESSELATOR)

	j_concur.ConcurrentLinkedQueue_init(&recording_queue)
	shader_light_directions = make(type_of(shader_light_directions), 2)
	PoseStack_init(&model_view_stack)
}

RenderSystem_init_render_thread :: proc()
{
	cthread := j_lang.Thread_current_thread()
	if RenderSystem_render_thread == nil && RenderSystem_game_thread != cthread {
		RenderSystem_render_thread = cthread
	} else {
		global.throw_unchecked({ .IllegalStateException }, "Could not initialize render thread")
	}
}

RenderSystem_init_game_thread :: proc(flag: bool)
{
	cthread := j_lang.Thread_current_thread()
	flag2 := (RenderSystem_render_thread == cthread)
	if RenderSystem_game_thread == nil && RenderSystem_render_thread != nil && flag2 != flag {
		RenderSystem_game_thread = cthread
	} else {
		global.throw_unchecked({ .IllegalStateException }, "Could not initialize tick thread")
	}
}

// @Static
RenderSystem_init_backend_system :: #force_inline proc() -> (j_func.LongSupplier)
{
	RenderSystem_assert_in_init_phase()
	return GLX_init_glfw()
}

/*
NOTE: See bottom of GLX_init_glfw body
*/
// @Static
RenderSystem_set_error_callback :: #force_inline proc(cb: glfw.ErrorProc)
{
	RenderSystem_assert_in_init_phase()
	GLX_set_glfw_error_callback(cb)
}

RenderSystem_is_on_render_thread :: #force_inline proc() -> (bool)
{
	return j_lang.Thread_current_thread() == RenderSystem_render_thread
}

RenderSystem_is_on_game_thread :: #force_inline proc() -> (bool)
{
	return true
}

@(private="file")
construct_thread_exception :: #force_inline proc() -> (global.ExceptionTypeSet, string)
{
	return { .IllegalStateException }, "RenderSystem called from wrong thread!"
}

// @Static
RenderSystem_assert_in_init_phase :: #force_inline proc(loc := #caller_location)
{
	// fmt.println("ASSERT AT:", loc)
	assert(RenderSystem_is_in_init_phase(), /*fmt.aprintf*/("RenderSystem_assert_in_init_phase FAILED!"))
}

// @Static
RenderSystem_assert_on_render_thread :: #force_inline proc(loc := #caller_location)
{
	// fmt.println("ASSERT AT:", loc)
	assert(RenderSystem_is_on_render_thread())
}

// @Static
RenderSystem_assert_on_render_thread_or_init :: /*#force_inline*/ proc(loc := #caller_location)
{
	if !is_in_init && !RenderSystem_is_on_render_thread()
	{
		global.throw_unchecked(construct_thread_exception())
	}
}

// @Static
RenderSystem_assert_on_game_thread_or_init :: proc()
{
	if !is_in_init && !RenderSystem_is_on_game_thread()
	{
		global.throw_unchecked({ .Exception }, "RenderSystem game thread or init assert failed!")
	}
}

// @Static
RenderSystem_is_in_init_phase :: #force_inline proc() -> (bool)
{
	// Uh lol
	return true
}

// @Static
RenderSystem_begin_initialization :: #force_inline proc()
{
	is_in_init = true
}

// @Static
RenderSystem_finish_initialization :: proc()
{
	is_in_init = false
	
	if !(j_concur.ConcurrentLinkedQueue_len(recording_queue) < 1) // check if empty
	{
		RenderSystem_replay_queue()
	}

	if !(j_concur.ConcurrentLinkedQueue_len(recording_queue) < 1) // check if empty
	{
		global.throw_unchecked({ .IllegalStateException }, "Recorded to render queue during init.")
	}
}

// @Static
RenderSystem_flip_frame :: proc(win_hnd: glfw.WindowHandle)
{
	glfw.PollEvents()
	RenderSystem_replay_queue()
	// Tesselator.getInstance().getBuilder().clear()
	BufferBuilder_clear(&(Tesselator_get_instance().builder))
	glfw.SwapBuffers(win_hnd)
	glfw.PollEvents()
}

// @Static
RenderSystem_record_render_call :: proc(ctx: rawptr, call: RenderCallProc)
{
	j_concur.ConcurrentLinkedQueue_add(&recording_queue, RenderCall{ ctx = ctx, execute = call })
}

// @Static
RenderSystem_replay_queue :: proc()
{
	is_replaying_queue = true

	for j_concur.ConcurrentLinkedQueue_len(recording_queue) > 0
	{
		rcall, worked := j_concur.ConcurrentLinkedQueue_pop_front(&recording_queue)
		assert(worked)
		rcall.execute(rcall.ctx)
	}

	is_replaying_queue = false
}

// @Static
RenderSystem_init_renderer :: proc(i: int, b: bool)
{
	RenderSystem_assert_in_init_phase()
	GLX_init(i, b)
	api_desc = GLX_get_opengl_version_string()
}

// @Static
RenderSystem_clear :: proc(flags: u32, is_osx: bool)
{
	RenderSystem_assert_on_game_thread_or_init()
	GlStateManager_glClear(flags, is_osx)
}

// @Static
RenderSystem_max_supported_tex_size :: proc() -> (int)
{
	if MAX_SUPPORTED_TEX_SIZE == -1
	{
		RenderSystem_assert_on_render_thread_or_init()
		i := GlStateManager_glGetInteger(3379)

		for j := max(32768, i); j >= 1_024; j >>= 1
		{
			GlStateManager_glTexImage2D(32868, 0, 6408, j, j, 0, 6408, 5121, nil)
			k := GlStateManager_glGetTexLevelParameter(32868, 0, 4_096)
			if k != 0
			{
				MAX_SUPPORTED_TEX_SIZE = cast(int) j
				return cast(int) j
			}
		}

		MAX_SUPPORTED_TEX_SIZE = cast(int) max(i, 1_024)
		logging.log(.Info, "Failed to determine maximum tex size by probing, trying GL_MAX_TEXTURE_SIZE.")
	}

	return MAX_SUPPORTED_TEX_SIZE
}

RenderSystem_setup_default_state :: proc(i1, i2, i3, i4: i32)
{
	RenderSystem_assert_in_init_phase()

	GlStateManager_enable_texture()
	GlStateManager_glClearDepth(1.0)
	GlStateManager_enable_depth_test()
	GlStateManager_glDepthFunc(515)
	
	cm_math.Matrix4f_set_ident(&projection_matrix)
	cm_math.Matrix4f_set_ident(&saved_projection_matrix)
	cm_math.Matrix4f_set_ident(&model_view_matrix)
	cm_math.Matrix4f_set_ident(&texture_matrix)

	GlStateManager_glViewport(i1, i2, i3, i4)
}

RenderSystem_get_model_view_stack :: #force_inline proc() -> (^PoseStack)
{
	return &model_view_stack
}

tmp_param: ^cm_math.Matrix4f
RenderSystem_apply_model_view_matrix :: proc()
{
	m4f := cm_math.Matrix4f_copy(&(PoseStack_get_last(&model_view_stack).pose))
	if !RenderSystem_is_on_render_thread()
	{
		tmp_param = new_clone(m4f)
		RenderSystem_record_render_call(&tmp_param, proc(_this: rawptr)
		{
			m4f := (^cm_math.Matrix4f)(_this)
			model_view_matrix = m4f^
			free(m4f)
		})
	} else
	{
		model_view_matrix = m4f
	}
}

// @Static
RenderSystem_viewport :: proc(x, y, w, h: i32)
{
	RenderSystem_assert_on_game_thread_or_init()
	GlStateManager_glViewport(x, y, w, h)
}

// @Static
RenderSystem_set_projection_matrix :: proc(m4f: ^cm_math.Matrix4f)
{
	_m4f := cm_math.Matrix4f_copy(m4f)
	if !RenderSystem_is_on_render_thread()
	{
		RenderSystem_record_render_call(new_clone(_m4f), proc(_this: rawptr)
		{
			this := (^cm_math.Matrix4f)(_this)
			projection_matrix = this^

			free(this)
		})
	} else
	{
		projection_matrix = _m4f
	}
}

RenderSystem_set_shader_lights :: proc(v1, v2: ^cm_math.Vector3f)
{
	RenderSystem_assert_on_render_thread()
	RenderSystem__set_shader_lights(v1, v2)
}

RenderSystem__set_shader_lights :: proc(v1, v2: ^cm_math.Vector3f)
{
	shader_light_directions[0] = v1^
	shader_light_directions[1] = v2^
}

RenderSystem_setup_gui_3D_diffuse_lighting :: proc(l1, l2: ^cm_math.Vector3f)
{
	RenderSystem_assert_on_render_thread()
	GlStateManager_setup_gui_3D_diffuse_lighting(l1, l2)
}

RenderSystem_disable_texture :: proc()
{
	RenderSystem_assert_on_render_thread()
	GlStateManager_disable_texture()
}

RenderSystem_blend_func_separate_factors :: proc(src1: SourceFactor, dest1: DestFactor, src2: SourceFactor, dest2: DestFactor)
{
	RenderSystem_assert_on_render_thread()
	GlStateManager__blend_func_separate(u32(src1), u32(dest1), u32(src2), u32(dest2))
}
RenderSystem_blend_func_separate_ints :: proc(i1, i2, i3, i4: u32)
{
	RenderSystem_assert_on_render_thread()
	GlStateManager__blend_func_separate(i1, i2, i3, i4)
}
RenderSystem_blend_func_separate :: proc{
	RenderSystem_blend_func_separate_factors,
	RenderSystem_blend_func_separate_ints,
}

RenderSystem_default_blend_func :: proc()
{
	RenderSystem_blend_func_separate_factors(.SrcAlpha, .OneMinusSrcAlpha, .One, .Zero)
}

RenderSystem_enable_blend :: proc()
{
	RenderSystem_assert_on_render_thread()
	GlStateManager__enable_blend()
}

@private
shader: ^mc_common.ShaderInstance = nil

@private
_tmp_param_si: j_func.Supplier(^mc_common.ShaderInstance)
RenderSystem_set_shader :: proc(si: j_func.Supplier(^mc_common.ShaderInstance))
{
	if !RenderSystem_is_on_render_thread()
	{
		_tmp_param_si = si
		RenderSystem_record_render_call(nil, proc(ctx: rawptr)
		{
			_tmp_param_si.get(ctx)
		})
	} else
	{
		shader = si.get(nil)
	}
}

RenderSystem_get_shader :: #force_inline proc() -> (^mc_common.ShaderInstance)
{
	RenderSystem_assert_on_render_thread()
	return shader
}








// Lighting static class
DIFFUSE_LIGHT_0: cm_math.Vector3f
DIFFUSE_LIGHT_1: cm_math.Vector3f

Lighting_INIT :: proc()
{
	DIFFUSE_LIGHT_0 = cm_math.Vector3f{ 0.2, 1.0, -0.7 }
	cm_math.Vector3f_normalize(&DIFFUSE_LIGHT_0)

	DIFFUSE_LIGHT_1 = cm_math.Vector3f{ -0.2, 1.0, 0.7 }
	cm_math.Vector3f_normalize(&DIFFUSE_LIGHT_1)
}

Lighting_setup_for_3D_items :: proc()
{
	RenderSystem_setup_gui_3D_diffuse_lighting(&DIFFUSE_LIGHT_0, &DIFFUSE_LIGHT_1)
}