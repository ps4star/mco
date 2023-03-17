package cm_blaze3d

import cm_math "mco:extern/com_mojang/math"

// !!!!!!!!
import ogl "vendor:OpenGL"
import JGL "mco:extern/org_lwjgl/lwjgl/opengl"

@(private="file")
ON_LINUX :: true when ODIN_OS == .Linux else false
GlStateManager_TEXTURE_COUNT :: 12

BLEND := BlendState{  }
DEPTH := DepthState{  }
CULL := CullState{  }
POLY_OFFSET := PolygonOffsetState{  }
COLOR_LOGIC := ColorLogicState{  }
STENCIL := StencilState{  }
SCISSOR := ScissorState{  }

active_texture: u32

TEXTURES := [12]TextureState{}
COLOR_MASK := ColorMask{  }

GlStateManager_INIT :: proc()
{
	BlendState_init(&BLEND)
	DepthState_init(&DEPTH)
	CullState_init(&CULL)
	PolygonOffsetState_init(&POLY_OFFSET)
	ColorLogicState_init(&COLOR_LOGIC)
	StencilState_init(&STENCIL)
	ScissorState_init(&SCISSOR)

	ColorMask_init(&COLOR_MASK)
}

	BlendState :: struct
	{
		mode: BooleanState,
		src_rgb: u32,
		dst_rgb: u32,
		src_alpha: u32,
		dst_alpha: u32,
	}

	BlendState_init :: proc(this: ^BlendState)
	{
		BooleanState_init(&this.mode, 3_042)
		this.src_rgb = 1
		this.dst_rgb = 0
		this.src_alpha = 1
		this.dst_alpha = 0
	}

	/*BlendState_set_enabled :: proc(this: ^BlendState, b: bool)
	{
		RenderSystem_assert_on_render_thread_or_init()
		if b != this.enabled
		{
			this.enabled = b
			if b
			{
				JGL.GL11_glEnable(this.state)
			} else
			{
				JGL.GL11_glDisable(this.state)
			}
		}
	}

	BlendState_enable :: #force_inline proc(this: ^BlendState)
	{
		BlendState_set_enabled(this, true)
	}

	BlendState_disable :: #force_inline proc(this: ^BlendState)
	{
		BlendState_set_enabled(this, false)
	}*/








	TextureState :: struct
	{
		enable: bool,
		binding: u32,
	}




	BooleanState :: struct
	{
		state: int, // does not change
		enabled: bool, // can change
	}

	BooleanState_init :: #force_inline proc(this: ^BooleanState, n: int) { this.state = n }
	BooleanState_new :: proc(n: int) -> (BooleanState) { out: BooleanState; BooleanState_init(&out, n); return out }
	BooleanState_disable :: #force_inline proc(this: ^BooleanState) { BooleanState_set_enabled(this, false) }
	BooleanState_enable :: #force_inline proc(this: ^BooleanState) { BooleanState_set_enabled(this, true) }
	BooleanState_set_enabled :: proc(this: ^BooleanState, b: bool)
	{
		RenderSystem_assert_on_render_thread_or_init()
		if b != this.enabled
		{
			this.enabled = b
			if b
			{
				JGL.GL11_glEnable(this.state)
			} else
			{
				JGL.GL11_glDisable(this.state)
			}
		}
	}




	ColorLogicState :: struct
	{
		enable: BooleanState, // BooleanState(3_058)
		op: int, // 5379
	}

	ColorLogicState_init :: proc(this: ^ColorLogicState)
	{
		BooleanState_init(&this.enable, 3_058)
		this.op = 5_379
	}




	ColorMask :: struct
	{
		red, green, blue, alpha: bool,
	}

	ColorMask_init :: proc(this: ^ColorMask)
	{
		this.red = true
		this.green = true
		this.blue = true
		this.alpha = true
	}




	CullState :: struct
	{
		enable: BooleanState, // BooleanState_init(2884)
		mode: int, // 1029
	}

	CullState_init :: proc(this: ^CullState)
	{
		BooleanState_init(&this.enable, 2884)
		this.mode = 1_029
	}



	DepthState :: struct
	{
		mode: BooleanState,
		mask: bool, // true
		func: u32, // 513
	}

	DepthState_init :: proc(this: ^DepthState)
	{
		BooleanState_init(&this.mode, 2929)
		this.mask = true
		this.func = 513
	}

	PolygonOffsetState :: struct
	{
		fill: BooleanState,
		line: BooleanState,
		factor, units: f32,
	}

	PolygonOffsetState_init :: proc(this: ^PolygonOffsetState)
	{
		BooleanState_init(&this.fill, 32_823)
		BooleanState_init(&this.line, 10_754)
	}

	StencilFunc :: struct
	{
		func: int, // 519
		ref: int,
		mask: int, // -1
	}

	StencilFunc_init :: proc(this: ^StencilFunc)
	{
		this.func = 519
		this.mask = -1
	}

	StencilState :: struct
	{
		func: StencilFunc,
		mask, fail, zfail, zpass: int,
	}

	StencilState_init :: proc(this: ^StencilState)
	{
		StencilFunc_init(&this.func)
		this.mask = -1
		this.fail = 7_680
		this.zfail = 7_680
		this.zpass = 7_680
	}

	ScissorState :: struct
	{
		mode: BooleanState,
	}

	ScissorState_init :: proc(this: ^ScissorState)
	{
		BooleanState_init(&this.mode, 3_089)
	}

/*	SourceFactor :: enum
	{
		ConstantAlpha,
		ConstantColor,
		DstAlpha,
		DstColor,
		One,
		OneMinusConstantAlpha,
		OneMinusConstantColor,
		OneMinusDstAlpha,
		OneMinusDstColor,
		OneMinusSrcAlpha,
		OneMinusSrcColor,
		SrcAlpha,
		SrcAlphaSaturate,
		SrcColor,
		Zero,
	}

	SourceFactorValue :: struct
	{
		value: int,
	}

	SourceFactorValues := [SourceFactor]SourceFactorValue{
		.ConstantAlpha = { 32771 },
		.ConstantColor = { 32769 },
		.DstAlpha = { 772 },
		.DstColor = { 774 },
		.One = { 1 },
		.OneMinusConstantAlpha = { 32772 },
		.OneMinusConstantColor = { 32770 },
		.OneMinusDstAlpha = { 773 },
		.OneMinusDstColor = { 775 },
		.OneMinusSrcAlpha = { 771 },
		.OneMinusSrcColor = { 769 },
		.SrcAlpha = { 770 },
		.SrcAlphaSaturate = { 776 },
		.SrcColor = { 768 },
		.Zero = { 0 },
	}

	SourceFactor_get :: proc(s: SourceFactor) -> (SourceFactorValue)
	{
		return SourceFactorValues[s]
	}*/

	Viewport :: struct
	{
		x, y, w, h: int,
	}
	Viewport_INST := Viewport{}



GlStateManager_disable_scissor_test :: proc()
{
	RenderSystem_assert_on_render_thread_or_init()

}

GlStateManager_glBindVertexArray :: proc(i: int)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL30_glBindVertexArray(i)
}

GlStateManager_glBindTexture :: proc(tex_id: u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	if tex_id != TEXTURES[active_texture].binding
	{
		TEXTURES[active_texture].binding = tex_id
		JGL.GL11_glBindTexture(3553, tex_id)
	}
}

GlStateManager_glGetError :: proc() -> (u32)
{
	RenderSystem_assert_on_render_thread()
	return JGL.GL11_glGetError()
}

GlStateManager_glClear :: proc(mask: u32, is_osx: bool)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL11_glClear(mask)
	if is_osx
	{
		GlStateManager_glGetError()
	}
}

GlStateManager_glGetString :: proc(i: u32) -> (cstring)
{
	RenderSystem_assert_on_render_thread()
	return JGL.GL11_glGetString(i)
}

GlStateManager_glGenTextures_1 :: proc() -> ([]u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	return JGL.GL11_glGenTextures()
}
GlStateManager_glGenTextures_m :: proc(arr: []u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL11_glGenTextures(arr)
}
GlStateManager_glGenTextures :: proc{
	GlStateManager_glGenTextures_1,
	GlStateManager_glGenTextures_m,
}

GlStateManager_glGetInteger :: proc(i: u32) -> (i32)
{
	RenderSystem_assert_on_render_thread_or_init()
	return JGL.GL11_glGetInteger(i)
}

GlStateManager_glGetTexLevelParameter :: proc(targ: u32, level: i32, pname: u32) -> (i32)
{
	return JGL.GL11_glGetTexLevelParameteri(targ, level, pname)
}

GlStateManager_glTexImage2D :: proc(targ: u32,
	level: i32,
	internal_fmt: i32,
	width: i32,
	height: i32,
	border: i32,
	fmt: u32,
	type: u32,
	data: rawptr)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL11_glTexImage2D(targ, level, internal_fmt, width, height, border, fmt, type, data)
}

GlStateManager_enable_texture :: proc()
{
	RenderSystem_assert_on_render_thread_or_init()
	TEXTURES[active_texture].enable = true
}

GlStateManager_disable_texture :: proc()
{
	RenderSystem_assert_on_render_thread()
	TEXTURES[active_texture].enable = false
}

GlStateManager_glClearDepth :: proc(f: f64)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL11_glClearDepth(f)
}

GlStateManager_enable_depth_test :: proc()
{
	RenderSystem_assert_on_render_thread_or_init()
	BooleanState_enable(&DEPTH.mode)
}

GlStateManager_glDepthFunc :: proc(i: u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	if i != DEPTH.func
	{
		DEPTH.func = i
		JGL.GL11_glDepthFunc(i)
	}
}

GlStateManager_glViewport :: proc(i1, i2, i3, i4: i32)
{
	JGL.GL11_glViewport(i1, i2, i3, i4)
}

GlStateManager_glBindFramebuffer :: proc(targ, fbuf: u32)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL30_glBindFramebuffer(targ, fbuf)
}

GlStateManager_glClearColor :: proc(r, g, b, a: f32)
{
	RenderSystem_assert_on_render_thread_or_init()
	JGL.GL11_glClearColor(r, g, b, a)
}

GlStateManager_setup_level_diffuse_lighting :: proc(l1, l2: ^cm_math.Vector3f, m: ^cm_math.Matrix4f)
{
	RenderSystem_assert_on_render_thread()
	v4f := cm_math.Vector4f_new(l1)
	cm_math.Vector4f_transform(&v4f, m)

	v4f1 := cm_math.Vector4f_new(l2)
	cm_math.Vector4f_transform(&v4f1, m)

	temp1 := cm_math.Vector3f_new(&v4f)
	temp2 := cm_math.Vector3f_new(&v4f1)
	RenderSystem_set_shader_lights(&temp1, &temp2)
}

GlStateManager_setup_gui_3D_diffuse_lighting :: proc(l1, l2: ^cm_math.Vector3f)
{
	RenderSystem_assert_on_render_thread()
	m4f := cm_math.Matrix4f_new()
	cm_math.Matrix4f_set_ident(&m4f)

	cm_math.Matrix4f_multiply(&m4f, cm_math.Vector3f_rotation_degrees(&cm_math.Vector3f_YP, 62.0))
	cm_math.Matrix4f_multiply(&m4f, cm_math.Vector3f_rotation_degrees(&cm_math.Vector3f_XP, 185.5))
	cm_math.Matrix4f_multiply(&m4f, cm_math.Vector3f_rotation_degrees(&cm_math.Vector3f_YP, -22.5))
	cm_math.Matrix4f_multiply(&m4f, cm_math.Vector3f_rotation_degrees(&cm_math.Vector3f_XP, 135.0))

	GlStateManager_setup_level_diffuse_lighting(l1, l2, &m4f)
}

GlStateManager_glBlendFuncSeparate :: proc(i1, i2, i3, i4: u32)
{
	RenderSystem_assert_on_render_thread()
	JGL.GL14_glBlendFuncSeparate(i1, i2, i3, i4)
}

GlStateManager__blend_func_separate :: proc(i1, i2, i3, i4: u32)
{
	RenderSystem_assert_on_render_thread()
	if i1 != BLEND.src_rgb || i2 != BLEND.dst_rgb || i3 != BLEND.src_alpha || i4 != BLEND.dst_alpha
	{
		BLEND.src_rgb = i1
		BLEND.dst_rgb = i2
		BLEND.src_alpha = i3
		BLEND.dst_alpha = i4
		GlStateManager_glBlendFuncSeparate(i1, i2, i3, i4)
	}
}

GlStateManager_glAttachShader :: proc(i1, i2: u32)
{
	RenderSystem_assert_on_render_thread()
	JGL.GL20_glAttachShader(i1, i2)
}

GlStateManager__enable_blend :: proc()
{
	RenderSystem_assert_on_render_thread()
	BooleanState_enable(&(BLEND.mode))
}

GlStateManager_glDeleteShader :: proc(i1: u32)
{
	RenderSystem_assert_on_render_thread()
	JGL.GL20_glDeleteShader(i1)
}





DestFactor :: enum u32
{
	ConstantAlpha = 32771,
	ConstantColor = 32769,
	DstAlpha = 772,
	DstColor = 774,
	One = 1,
	OneMinusConstantAlpha = 32772,
	OneMinusConstantColor = 32770,
	OneMinusDstAlpha = 773,
	OneMinusDstColor = 775,
	OneMinusSrcAlpha = 771,
	OneMinusSrcColor = 769,
	SrcAlpha = 770,
	SrcColor = 768,
	Zero = 0,
}

SourceFactor :: enum u32
{
	ConstantAlpha = 32771,
	ConstantColor = 32769,
	DstAlpha = 772,
	DstColor = 774,
	One = 1,
	OneMinusConstantAlpha = 32772,
	OneMinusConstantColor = 32770,
	OneMinusDstAlpha = 773,
	OneMinusDstColor = 775,
	OneMinusSrcAlpha = 771,
	OneMinusSrcColor = 769,
	SrcAlpha = 770,
	SrcAlphaSaturate = 776,
	SrcColor = 768,
	Zero = 0,
}