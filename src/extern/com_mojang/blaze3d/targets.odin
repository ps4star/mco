package cm_blaze3d

import global "mco:odin/global"
import conf "mco:odin/conf"

RenderTarget :: struct
{
	width, height: int,
	view_width, view_height: int,
	use_depth: bool, // @Final
	frame_buffer_id: u32,
	color_texture_id: u32,
	depth_buffer_id: u32,

	clear_channels: []f32, // @DynamicDefault {1.0, 1.0, 1.0, 0.0}
	filter_mode: int,

	__tmp_param1: bool,
}

RenderTarget_init :: proc(this: ^RenderTarget, use_depth: bool)
{
	this.use_depth = use_depth
	this.frame_buffer_id = transmute(u32) i32(-1)
	this.color_texture_id = transmute(u32) i32(-1)
	this.depth_buffer_id = transmute(u32) i32(-1)

	// Dynamic defaults
	this.clear_channels = make([]f32, 4)
	this.clear_channels[0] = 1.0
	this.clear_channels[1] = 1.0
	this.clear_channels[2] = 1.0
	this.clear_channels[3] = 0.0
}

RenderTarget_set_clear_color :: proc(this: ^RenderTarget, r, g, b, a: f32)
{
	this.clear_channels[0] = r
	this.clear_channels[1] = g
	this.clear_channels[2] = b
	this.clear_channels[3] = a
}

RenderTarget_clear :: proc(this: ^RenderTarget, flag: bool)
{
	RenderSystem_assert_on_render_thread_or_init()
	RenderTarget_bind_write(this, true)
	GlStateManager_glClearColor(this.clear_channels[0], this.clear_channels[1], this.clear_channels[2], this.clear_channels[3])
	i := 16384
	if this.use_depth
	{
		GlStateManager_glClearDepth(1.0)
		i |= 256
	}

	GlStateManager_glClear(u32(i), flag)
	RenderTarget_unbind_write(this)
}

RenderTarget_bind_write :: proc(this: ^RenderTarget, flag: bool)
{
	if !RenderSystem_is_on_render_thread()
	{
		this.__tmp_param1 = flag
		RenderSystem_record_render_call(this, proc(_this: rawptr)
		{
			this := (^RenderTarget)(_this)
			RenderTarget__bind_write(this, this.__tmp_param1)
		})
	} else
	{
		RenderTarget__bind_write(this, flag)
	}
}

RenderTarget__bind_write :: proc(this: ^RenderTarget, flag: bool)
{
	RenderSystem_assert_on_render_thread_or_init()
	GlStateManager_glBindFramebuffer(36160, this.frame_buffer_id)
	if flag
	{
		GlStateManager_glViewport(0, 0, cast(i32) this.view_width, cast(i32) this.view_height)
	}
}

RenderTarget_unbind_write :: proc(this: ^RenderTarget)
{
	if !RenderSystem_is_on_render_thread()
	{
		RenderSystem_record_render_call(nil, proc(_this: rawptr)
		{
			GlStateManager_glBindFramebuffer(36160, 0)
		})
	} else
	{
		GlStateManager_glBindFramebuffer(36160, 0)
	}
}







MainTarget :: struct
{
	using rtarg: RenderTarget,
	_tmp_param1, _tmp_param2: int,
}

MainTarget_init :: proc(this: ^MainTarget, i1, i2: int)
{
	RenderTarget_init(&this.rtarg, true)
	RenderSystem_assert_on_render_thread_or_init()
	if !RenderSystem_is_on_render_thread()
	{
		// Store params for later render call
		this._tmp_param1 = i1
		this._tmp_param2 = i2
		RenderSystem_record_render_call(this, proc(_this: rawptr)
		{
			this := (^MainTarget)(_this)
			MainTarget_create_frame_buffer(this, this._tmp_param1, this._tmp_param2)
		})
	} else
	{
		MainTarget_create_frame_buffer(this, i1, i2)
	}
}

MainTarget_create_frame_buffer :: proc(this: ^MainTarget, i1, i2: int)
{
	RenderSystem_assert_on_render_thread_or_init()
	mtd := MainTarget_allocate_attachments(this, i1, i2)
}

MainTarget_allocate_attachments :: proc(this: ^MainTarget, i1, i2: int) -> (MTDimension)
{
	RenderSystem_assert_on_render_thread_or_init()
	this.color_texture_id = TexUtil_gen_tex_id()
	this.depth_buffer_id = TexUtil_gen_tex_id()

	mt_as := MTAttachState.None

	mtdl := MTDimension_list_with_fallback(i1, i2)
	for mtd in mtdl
	{
		mt_as = .None
		if MainTarget_allocate_color_attachment(this, mtd)
		{
			mt_as = MTAttachState_with(mt_as, .Color)
		}

		if MainTarget_allocate_depth_attachment(this, mtd)
		{
			mt_as = MTAttachState_with(mt_as, .Depth)
		}

		if mt_as == .ColorDepth
		{
			delete(mtdl)
			return mtd
		}
	}

	delete(mtdl)
	global.throw_unchecked({ .RuntimeException }, "Out of memory!")
	panic("")
}

MainTarget_allocate_color_attachment :: proc(this: ^MainTarget, mtd: MTDimension) -> (bool)
{
	RenderSystem_assert_on_render_thread_or_init()
	GlStateManager_glGetError()
	GlStateManager_glBindTexture(this.color_texture_id)
	GlStateManager_glTexImage2D(3553, 0, 32856, i32(mtd.w), i32(mtd.h), 0, 6408, 5121, nil)
	return GlStateManager_glGetError() != 1285
}

MainTarget_allocate_depth_attachment :: proc(this: ^MainTarget, mtd: MTDimension) -> (bool)
{
	RenderSystem_assert_on_render_thread_or_init()
	GlStateManager_glGetError()
	GlStateManager_glBindTexture(this.depth_buffer_id)
	GlStateManager_glTexImage2D(3553, 0, 6402, i32(mtd.w), i32(mtd.h), 0, 6402, 5126, nil)
	return GlStateManager_glGetError() != 1285
}







	MTDimension :: struct
	{
		w, h: int,
	}

	MTDimension_init :: #force_inline proc(this: ^MTDimension, w, h: int)
	{
		this.w = w
		this.h = h
	}

	DEFAULT_DIMENSIONS := MTDimension{ 854, 480 }
	MTDimension_list_with_fallback :: proc(i1, i2: int) -> ([]MTDimension)
	{
		RenderSystem_assert_on_render_thread_or_init()
		i := RenderSystem_max_supported_tex_size()

		cond := (i1 > 0 && i1 <= i && i2 > 0 && i2 <= i)
		if cond
		{
			out := make([]MTDimension, 2)
			MTDimension_init(&out[0], i1, i2)
			out[1] = DEFAULT_DIMENSIONS
			return out
		}
		
		out := make([]MTDimension, 1)
		out[0] = DEFAULT_DIMENSIONS
		return out
	}






	MTAttachState :: enum int
	{
		None,
		Color,
		Depth,
		ColorDepth,
	}

	MTAttachStateValue :: MTAttachState
	/*MTAttachStateValues := [MTAttachState]MTAttachStateValue{ // identity array
		.None = .None,
		.Color = .Color,
		.Depth = .Depth,
		.ColorDepth = .ColorDepth,
	}*/

	MTAttachState_with :: #force_inline proc(this, other: MTAttachState) -> (MTAttachState)
	{
		return cast(MTAttachState) (int(this) | int(other))
	}