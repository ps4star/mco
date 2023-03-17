package opengl

/** Accepted by the {@code pname} parameter of TexParameteri TexParameterf TexParameteriv TexParameterfv GetTexParameteriv and GetTexParameterfv. */
 GL14_GL_GENERATE_MIPMAP :: 0x8191

/** Accepted by the {@code target} parameter of Hint and by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
 GL14_GL_GENERATE_MIPMAP_HINT :: 0x8192

/** Accepted by the {@code sfactor} and {@code dfactor} parameters of BlendFunc. */

GL14_GL_CONSTANT_COLOR           :: 0x8001
GL14_GL_ONE_MINUS_CONSTANT_COLOR :: 0x8002
GL14_GL_CONSTANT_ALPHA           :: 0x8003
GL14_GL_ONE_MINUS_CONSTANT_ALPHA :: 0x8004

/** Accepted by the {@code mode} parameter of BlendEquation. */

GL14_GL_FUNC_ADD :: 0x8006
GL14_GL_MIN      :: 0x8007
GL14_GL_MAX      :: 0x8008

/** Accepted by the {@code mode} parameter of BlendEquation. */

GL14_GL_FUNC_SUBTRACT         :: 0x800A
GL14_GL_FUNC_REVERSE_SUBTRACT :: 0x800B

/** Accepted by the {@code internalFormat} parameter of TexImage1D TexImage2D CopyTexImage1D and CopyTexImage2D. */

GL14_GL_DEPTH_COMPONENT16 :: 0x81A5
GL14_GL_DEPTH_COMPONENT24 :: 0x81A6
GL14_GL_DEPTH_COMPONENT32 :: 0x81A7

/** Accepted by the {@code pname} parameter of GetTexLevelParameterfv and GetTexLevelParameteriv. */
 GL14_GL_TEXTURE_DEPTH_SIZE :: 0x884A

/** Accepted by the {@code pname} parameter of TexParameterf TexParameteri TexParameterfv TexParameteriv GetTexParameterfv and GetTexParameteriv. */
 GL14_GL_DEPTH_TEXTURE_MODE :: 0x884B

/** Accepted by the {@code pname} parameter of TexParameterf TexParameteri TexParameterfv TexParameteriv GetTexParameterfv and GetTexParameteriv. */

GL14_GL_TEXTURE_COMPARE_MODE :: 0x884C
GL14_GL_TEXTURE_COMPARE_FUNC :: 0x884D

/**
* Accepted by the {@code param} parameter of TexParameterf TexParameteri TexParameterfv and TexParameteriv when the {@code pname} parameter is
* TEXTURE_COMPARE_MODE.
*/
 GL14_GL_COMPARE_R_TO_TEXTURE :: 0x884E

/** Accepted by the {@code pname} parameter of Fogi and Fogf. */
 GL14_GL_FOG_COORDINATE_SOURCE :: 0x8450

/** Accepted by the {@code param} parameter of Fogi and Fogf. */

GL14_GL_FOG_COORDINATE :: 0x8451
GL14_GL_FRAGMENT_DEPTH :: 0x8452

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL14_GL_CURRENT_FOG_COORDINATE      :: 0x8453
GL14_GL_FOG_COORDINATE_ARRAY_TYPE   :: 0x8454
GL14_GL_FOG_COORDINATE_ARRAY_STRIDE :: 0x8455

/** Accepted by the {@code pname} parameter of GetPointerv. */
 GL14_GL_FOG_COORDINATE_ARRAY_POINTER :: 0x8456

/** Accepted by the {@code array} parameter of EnableClientState and DisableClientState. */
 GL14_GL_FOG_COORDINATE_ARRAY :: 0x8457

/** Accepted by the {@code pname} parameter of PointParameterfARB and the {@code pname} of Get. */

GL14_GL_POINT_SIZE_MIN             :: 0x8126
GL14_GL_POINT_SIZE_MAX             :: 0x8127
GL14_GL_POINT_FADE_THRESHOLD_SIZE  :: 0x8128
GL14_GL_POINT_DISTANCE_ATTENUATION :: 0x8129

/**
* Accepted by the {@code cap} parameter of Enable Disable and IsEnabled and by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and
* GetDoublev.
*/
 GL14_GL_COLOR_SUM :: 0x8458

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL14_GL_CURRENT_SECONDARY_COLOR      :: 0x8459
GL14_GL_SECONDARY_COLOR_ARRAY_SIZE   :: 0x845A
GL14_GL_SECONDARY_COLOR_ARRAY_TYPE   :: 0x845B
GL14_GL_SECONDARY_COLOR_ARRAY_STRIDE :: 0x845C

/** Accepted by the {@code pname} parameter of GetPointerv. */
 GL14_GL_SECONDARY_COLOR_ARRAY_POINTER :: 0x845D

/** Accepted by the {@code array} parameter of EnableClientState and DisableClientState. */
 GL14_GL_SECONDARY_COLOR_ARRAY :: 0x845E

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL14_GL_BLEND_DST_RGB   :: 0x80C8
GL14_GL_BLEND_SRC_RGB   :: 0x80C9
GL14_GL_BLEND_DST_ALPHA :: 0x80CA
GL14_GL_BLEND_SRC_ALPHA :: 0x80CB

/** Accepted by the {@code sfail} {@code dpfail} and {@code dppass} parameter of StencilOp. */

GL14_GL_INCR_WRAP :: 0x8507
GL14_GL_DECR_WRAP :: 0x8508

/** Accepted by the {@code target} parameters of GetTexEnvfv GetTexEnviv TexEnvi TexEnvf Texenviv and TexEnvfv. */
 GL14_GL_TEXTURE_FILTER_CONTROL :: 0x8500

/**
* When the {@code target} parameter of GetTexEnvfv GetTexEnviv TexEnvi TexEnvf TexEnviv and TexEnvfv is TEXTURE_FILTER_CONTROL then the value of
* {@code pname} may be.
*/
 GL14_GL_TEXTURE_LOD_BIAS :: 0x8501

/** Accepted by the {@code pname} parameters of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
 GL14_GL_MAX_TEXTURE_LOD_BIAS :: 0x84FD

/**
* Accepted by the {@code param} parameter of TexParameteri and TexParameterf and by the {@code params} parameter of TexParameteriv and TexParameterfv
* when their {@code pname} parameter is TEXTURE_WRAP_S TEXTURE_WRAP_T or TEXTURE_WRAP_R.
*/
 GL14_GL_MIRRORED_REPEAT :: 0x8370