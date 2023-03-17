package opengl

/** GetTarget */

GL30_GL_MAJOR_VERSION                       :: 0x821B
GL30_GL_MINOR_VERSION                       :: 0x821C
GL30_GL_NUM_EXTENSIONS                      :: 0x821D
GL30_GL_CONTEXT_FLAGS                       :: 0x821E
GL30_GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT :: 0x1

/** Renamed tokens. */

GL30_GL_COMPARE_REF_TO_TEXTURE :: GL14_GL_COMPARE_R_TO_TEXTURE
GL30_GL_CLIP_DISTANCE0         :: GL11_GL_CLIP_PLANE0
GL30_GL_CLIP_DISTANCE1         :: GL11_GL_CLIP_PLANE1
GL30_GL_CLIP_DISTANCE2         :: GL11_GL_CLIP_PLANE2
GL30_GL_CLIP_DISTANCE3         :: GL11_GL_CLIP_PLANE3
GL30_GL_CLIP_DISTANCE4         :: GL11_GL_CLIP_PLANE4
GL30_GL_CLIP_DISTANCE5         :: GL11_GL_CLIP_PLANE5
GL30_GL_CLIP_DISTANCE6         :: 0x3006
GL30_GL_CLIP_DISTANCE7         :: 0x3007
GL30_GL_MAX_CLIP_DISTANCES     :: GL11_GL_MAX_CLIP_PLANES
GL30_GL_MAX_VARYING_COMPONENTS :: GL20_GL_MAX_VARYING_FLOATS

/** Accepted by the {@code pname} parameters of GetVertexAttribdv GetVertexAttribfv GetVertexAttribiv GetVertexAttribIuiv and GetVertexAttribIiv. */
 GL30_GL_VERTEX_ATTRIB_ARRAY_INTEGER :: 0x88FD

/** Returned by the {@code type} parameter of GetActiveUniform. */

GL30_GL_SAMPLER_1D_ARRAY              :: 0x8DC0
GL30_GL_SAMPLER_2D_ARRAY              :: 0x8DC1
GL30_GL_SAMPLER_1D_ARRAY_SHADOW       :: 0x8DC3
GL30_GL_SAMPLER_2D_ARRAY_SHADOW       :: 0x8DC4
GL30_GL_SAMPLER_CUBE_SHADOW           :: 0x8DC5
GL30_GL_UNSIGNED_INT_VEC2             :: 0x8DC6
GL30_GL_UNSIGNED_INT_VEC3             :: 0x8DC7
GL30_GL_UNSIGNED_INT_VEC4             :: 0x8DC8
GL30_GL_INT_SAMPLER_1D                :: 0x8DC9
GL30_GL_INT_SAMPLER_2D                :: 0x8DCA
GL30_GL_INT_SAMPLER_3D                :: 0x8DCB
GL30_GL_INT_SAMPLER_CUBE              :: 0x8DCC
GL30_GL_INT_SAMPLER_1D_ARRAY          :: 0x8DCE
GL30_GL_INT_SAMPLER_2D_ARRAY          :: 0x8DCF
GL30_GL_UNSIGNED_INT_SAMPLER_1D       :: 0x8DD1
GL30_GL_UNSIGNED_INT_SAMPLER_2D       :: 0x8DD2
GL30_GL_UNSIGNED_INT_SAMPLER_3D       :: 0x8DD3
GL30_GL_UNSIGNED_INT_SAMPLER_CUBE     :: 0x8DD4
GL30_GL_UNSIGNED_INT_SAMPLER_1D_ARRAY :: 0x8DD6
GL30_GL_UNSIGNED_INT_SAMPLER_2D_ARRAY :: 0x8DD7

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL30_GL_MIN_PROGRAM_TEXEL_OFFSET :: 0x8904
GL30_GL_MAX_PROGRAM_TEXEL_OFFSET :: 0x8905

/** Accepted by the {@code mode} parameter of BeginConditionalRender. */

GL30_GL_QUERY_WAIT              :: 0x8E13
GL30_GL_QUERY_NO_WAIT           :: 0x8E14
GL30_GL_QUERY_BY_REGION_WAIT    :: 0x8E15
GL30_GL_QUERY_BY_REGION_NO_WAIT :: 0x8E16

/** Accepted by the {@code access} parameter of MapBufferRange. */

GL30_GL_MAP_READ_BIT              :: 0x1
GL30_GL_MAP_WRITE_BIT             :: 0x2
GL30_GL_MAP_INVALIDATE_RANGE_BIT  :: 0x4
GL30_GL_MAP_INVALIDATE_BUFFER_BIT :: 0x8
GL30_GL_MAP_FLUSH_EXPLICIT_BIT    :: 0x10
GL30_GL_MAP_UNSYNCHRONIZED_BIT    :: 0x20

/** Accepted by the {@code pname} parameter of GetBufferParameteriv. */

GL30_GL_BUFFER_ACCESS_FLAGS :: 0x911F
GL30_GL_BUFFER_MAP_LENGTH   :: 0x9120
GL30_GL_BUFFER_MAP_OFFSET   :: 0x9121

/** Accepted by the {@code target} parameter of ClampColor and the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL30_GL_CLAMP_VERTEX_COLOR   :: 0x891A
GL30_GL_CLAMP_FRAGMENT_COLOR :: 0x891B
GL30_GL_CLAMP_READ_COLOR     :: 0x891C

/** Accepted by the {@code clamp} parameter of ClampColor. */
 GL30_GL_FIXED_ONLY :: 0x891D

/**
* Accepted by the {@code internalformat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D CopyTexImage2D and RenderbufferStorage and
* returned in the {@code data} parameter of GetTexLevelParameter and GetRenderbufferParameteriv.
*/

GL30_GL_DEPTH_COMPONENT32F :: 0x8CAC
GL30_GL_DEPTH32F_STENCIL8  :: 0x8CAD

/**
* Accepted by the {@code type} parameter of DrawPixels ReadPixels TexImage1D TexImage2D TexImage3D TexSubImage1D TexSubImage2D TexSubImage3D and
* GetTexImage.
*/
 GL30_GL_FLOAT_32_UNSIGNED_INT_24_8_REV :: 0x8DAD

/** Accepted by the {@code value} parameter of GetTexLevelParameter. */

GL30_GL_TEXTURE_RED_TYPE       :: 0x8C10
GL30_GL_TEXTURE_GREEN_TYPE     :: 0x8C11
GL30_GL_TEXTURE_BLUE_TYPE      :: 0x8C12
GL30_GL_TEXTURE_ALPHA_TYPE     :: 0x8C13
GL30_GL_TEXTURE_LUMINANCE_TYPE :: 0x8C14
GL30_GL_TEXTURE_INTENSITY_TYPE :: 0x8C15
GL30_GL_TEXTURE_DEPTH_TYPE     :: 0x8C16

/** Returned by the {@code params} parameter of GetTexLevelParameter. */
 GL30_GL_UNSIGNED_NORMALIZED :: 0x8C17

/** Accepted by the {@code internalFormat} parameter of TexImage1D TexImage2D and TexImage3D. */

GL30_GL_RGBA32F :: 0x8814
GL30_GL_RGB32F  :: 0x8815
GL30_GL_RGBA16F :: 0x881A
GL30_GL_RGB16F  :: 0x881B

/** Accepted by the {@code internalformat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D CopyTexImage2D and RenderbufferStorage. */
 GL30_GL_R11F_G11F_B10F :: 0x8C3A

/**
* Accepted by the {@code type} parameter of DrawPixels ReadPixels TexImage1D TexImage2D GetTexImage TexImage3D TexSubImage1D TexSubImage2D
* TexSubImage3D GetHistogram GetMinmax ConvolutionFilter1D ConvolutionFilter2D ConvolutionFilter3D GetConvolutionFilter SeparableFilter2D
* GetSeparableFilter ColorTable ColorSubTable and GetColorTable.
*/
 GL30_GL_UNSIGNED_INT_10F_11F_11F_REV :: 0x8C3B

/** Accepted by the {@code internalformat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D CopyTexImage2D and RenderbufferStorage. */
 GL30_GL_RGB9_E5 :: 0x8C3D

/**
* Accepted by the {@code type} parameter of DrawPixels ReadPixels TexImage1D TexImage2D GetTexImage TexImage3D TexSubImage1D TexSubImage2D
* TexSubImage3D GetHistogram GetMinmax ConvolutionFilter1D ConvolutionFilter2D ConvolutionFilter3D GetConvolutionFilter SeparableFilter2D
* GetSeparableFilter ColorTable ColorSubTable and GetColorTable.
*/
 GL30_GL_UNSIGNED_INT_5_9_9_9_REV :: 0x8C3E

/** Accepted by the {@code pname} parameter of GetTexLevelParameterfv and GetTexLevelParameteriv. */
 GL30_GL_TEXTURE_SHARED_SIZE :: 0x8C3F

/**
* Accepted by the {@code target} parameter of BindFramebuffer CheckFramebufferStatus FramebufferTexture{1D|2D|3D} FramebufferRenderbuffer and
* GetFramebufferAttachmentParameteriv.
*/

GL30_GL_FRAMEBUFFER      :: 0x8D40
GL30_GL_READ_FRAMEBUFFER :: 0x8CA8
GL30_GL_DRAW_FRAMEBUFFER :: 0x8CA9

/**
* Accepted by the {@code target} parameter of BindRenderbuffer RenderbufferStorage and GetRenderbufferParameteriv and returned by
* GetFramebufferAttachmentParameteriv.
*/
 GL30_GL_RENDERBUFFER :: 0x8D41

/** Accepted by the {@code internalformat} parameter of RenderbufferStorage. */

GL30_GL_STENCIL_INDEX1  :: 0x8D46
GL30_GL_STENCIL_INDEX4  :: 0x8D47
GL30_GL_STENCIL_INDEX8  :: 0x8D48
GL30_GL_STENCIL_INDEX16 :: 0x8D49

/** Accepted by the {@code pname} parameter of GetRenderbufferParameteriv. */

GL30_GL_RENDERBUFFER_WIDTH           :: 0x8D42
GL30_GL_RENDERBUFFER_HEIGHT          :: 0x8D43
GL30_GL_RENDERBUFFER_INTERNAL_FORMAT :: 0x8D44
GL30_GL_RENDERBUFFER_RED_SIZE        :: 0x8D50
GL30_GL_RENDERBUFFER_GREEN_SIZE      :: 0x8D51
GL30_GL_RENDERBUFFER_BLUE_SIZE       :: 0x8D52
GL30_GL_RENDERBUFFER_ALPHA_SIZE      :: 0x8D53
GL30_GL_RENDERBUFFER_DEPTH_SIZE      :: 0x8D54
GL30_GL_RENDERBUFFER_STENCIL_SIZE    :: 0x8D55
GL30_GL_RENDERBUFFER_SAMPLES         :: 0x8CAB

/** Accepted by the {@code pname} parameter of GetFramebufferAttachmentParameteriv. */

GL30_GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE           :: 0x8CD0
GL30_GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME           :: 0x8CD1
GL30_GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL         :: 0x8CD2
GL30_GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE :: 0x8CD3
GL30_GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER         :: 0x8CD4
GL30_GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING        :: 0x8210
GL30_GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE        :: 0x8211
GL30_GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE              :: 0x8212
GL30_GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE            :: 0x8213
GL30_GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE             :: 0x8214
GL30_GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE            :: 0x8215
GL30_GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE            :: 0x8216
GL30_GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE          :: 0x8217

/** Returned in {@code params} by GetFramebufferAttachmentParameteriv. */

GL30_GL_FRAMEBUFFER_DEFAULT :: 0x8218
GL30_GL_INDEX               :: 0x8222

/** Accepted by the {@code attachment} parameter of FramebufferTexture{1D|2D|3D} FramebufferRenderbuffer and GetFramebufferAttachmentParameteriv. */

GL30_GL_COLOR_ATTACHMENT0        :: 0x8CE0
GL30_GL_COLOR_ATTACHMENT1        :: 0x8CE1
GL30_GL_COLOR_ATTACHMENT2        :: 0x8CE2
GL30_GL_COLOR_ATTACHMENT3        :: 0x8CE3
GL30_GL_COLOR_ATTACHMENT4        :: 0x8CE4
GL30_GL_COLOR_ATTACHMENT5        :: 0x8CE5
GL30_GL_COLOR_ATTACHMENT6        :: 0x8CE6
GL30_GL_COLOR_ATTACHMENT7        :: 0x8CE7
GL30_GL_COLOR_ATTACHMENT8        :: 0x8CE8
GL30_GL_COLOR_ATTACHMENT9        :: 0x8CE9
GL30_GL_COLOR_ATTACHMENT10       :: 0x8CEA
GL30_GL_COLOR_ATTACHMENT11       :: 0x8CEB
GL30_GL_COLOR_ATTACHMENT12       :: 0x8CEC
GL30_GL_COLOR_ATTACHMENT13       :: 0x8CED
GL30_GL_COLOR_ATTACHMENT14       :: 0x8CEE
GL30_GL_COLOR_ATTACHMENT15       :: 0x8CEF
GL30_GL_COLOR_ATTACHMENT16       :: 0x8CF0
GL30_GL_COLOR_ATTACHMENT17       :: 0x8CF1
GL30_GL_COLOR_ATTACHMENT18       :: 0x8CF2
GL30_GL_COLOR_ATTACHMENT19       :: 0x8CF3
GL30_GL_COLOR_ATTACHMENT20       :: 0x8CF4
GL30_GL_COLOR_ATTACHMENT21       :: 0x8CF5
GL30_GL_COLOR_ATTACHMENT22       :: 0x8CF6
GL30_GL_COLOR_ATTACHMENT23       :: 0x8CF7
GL30_GL_COLOR_ATTACHMENT24       :: 0x8CF8
GL30_GL_COLOR_ATTACHMENT25       :: 0x8CF9
GL30_GL_COLOR_ATTACHMENT26       :: 0x8CFA
GL30_GL_COLOR_ATTACHMENT27       :: 0x8CFB
GL30_GL_COLOR_ATTACHMENT28       :: 0x8CFC
GL30_GL_COLOR_ATTACHMENT29       :: 0x8CFD
GL30_GL_COLOR_ATTACHMENT30       :: 0x8CFE
GL30_GL_COLOR_ATTACHMENT31       :: 0x8CFF
GL30_GL_DEPTH_ATTACHMENT         :: 0x8D00
GL30_GL_STENCIL_ATTACHMENT       :: 0x8D20
GL30_GL_DEPTH_STENCIL_ATTACHMENT :: 0x821A

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
 GL30_GL_MAX_SAMPLES :: 0x8D57

/** Returned by CheckFramebufferStatus(). */

GL30_GL_FRAMEBUFFER_COMPLETE                      :: 0x8CD5
GL30_GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT         :: 0x8CD6
GL30_GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT :: 0x8CD7
GL30_GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER        :: 0x8CDB
GL30_GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER        :: 0x8CDC
GL30_GL_FRAMEBUFFER_UNSUPPORTED                   :: 0x8CDD
GL30_GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE        :: 0x8D56
GL30_GL_FRAMEBUFFER_UNDEFINED                     :: 0x8219

/** Accepted by the {@code pname} parameters of GetIntegerv GetFloatv  and GetDoublev. */

GL30_GL_FRAMEBUFFER_BINDING      :: 0x8CA6
GL30_GL_DRAW_FRAMEBUFFER_BINDING :: 0x8CA6
GL30_GL_READ_FRAMEBUFFER_BINDING :: 0x8CAA
GL30_GL_RENDERBUFFER_BINDING     :: 0x8CA7
GL30_GL_MAX_COLOR_ATTACHMENTS    :: 0x8CDF
GL30_GL_MAX_RENDERBUFFER_SIZE    :: 0x84E8

/** Returned by GetError(). */
 GL30_GL_INVALID_FRAMEBUFFER_OPERATION :: 0x506

/**
* Accepted by the {@code format} parameter of DrawPixels ReadPixels TexImage1D TexImage2D TexImage3D TexSubImage1D TexSubImage2D TexSubImage3D and
* GetTexImage by the {@code type} parameter of CopyPixels by the {@code internalformat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D
* CopyTexImage2D and RenderbufferStorage and returned in the {@code data} parameter of GetTexLevelParameter and GetRenderbufferParameteriv.
*/
 GL30_GL_DEPTH_STENCIL :: 0x84F9

/**
* Accepted by the {@code type} parameter of DrawPixels ReadPixels TexImage1D TexImage2D TexImage3D TexSubImage1D TexSubImage2D TexSubImage3D and
* GetTexImage.
*/
 GL30_GL_UNSIGNED_INT_24_8 :: 0x84FA

/**
* Accepted by the {@code internalformat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D CopyTexImage2D and RenderbufferStorage and
* returned in the {@code data} parameter of GetTexLevelParameter and GetRenderbufferParameteriv.
*/
 GL30_GL_DEPTH24_STENCIL8 :: 0x88F0

/** Accepted by the {@code value} parameter of GetTexLevelParameter. */
 GL30_GL_TEXTURE_STENCIL_SIZE :: 0x88F1

/**
* Accepted by the {@code type} parameter of DrawPixels ReadPixels TexImage1D TexImage2D TexImage3D GetTexImage TexSubImage1D TexSubImage2D
* TexSubImage3D GetHistogram GetMinmax ConvolutionFilter1D ConvolutionFilter2D GetConvolutionFilter SeparableFilter2D GetSeparableFilter
* ColorTable ColorSubTable and GetColorTable.
* 
* <p>Accepted by the {@code type} argument of VertexPointer NormalPointer ColorPointer SecondaryColorPointer FogCoordPointer TexCoordPointer and
* VertexAttribPointer.</p>
*/
 GL30_GL_HALF_FLOAT :: 0x140B

/** Accepted by the {@code internalFormat} parameter of TexImage1D TexImage2D and TexImage3D. */

GL30_GL_RGBA32UI :: 0x8D70
GL30_GL_RGB32UI  :: 0x8D71
GL30_GL_RGBA16UI :: 0x8D76
GL30_GL_RGB16UI  :: 0x8D77
GL30_GL_RGBA8UI  :: 0x8D7C
GL30_GL_RGB8UI   :: 0x8D7D
GL30_GL_RGBA32I  :: 0x8D82
GL30_GL_RGB32I   :: 0x8D83
GL30_GL_RGBA16I  :: 0x8D88
GL30_GL_RGB16I   :: 0x8D89
GL30_GL_RGBA8I   :: 0x8D8E
GL30_GL_RGB8I    :: 0x8D8F

/** Accepted by the {@code format} parameter of TexImage1D TexImage2D TexImage3D TexSubImage1D TexSubImage2D TexSubImage3D DrawPixels and ReadPixels. */

GL30_GL_RED_INTEGER   :: 0x8D94
GL30_GL_GREEN_INTEGER :: 0x8D95
GL30_GL_BLUE_INTEGER  :: 0x8D96
GL30_GL_ALPHA_INTEGER :: 0x8D97
GL30_GL_RGB_INTEGER   :: 0x8D98
GL30_GL_RGBA_INTEGER  :: 0x8D99
GL30_GL_BGR_INTEGER   :: 0x8D9A
GL30_GL_BGRA_INTEGER  :: 0x8D9B

/** Accepted by the {@code target} parameter of TexParameteri TexParameteriv TexParameterf TexParameterfv GenerateMipmap and BindTexture. */

GL30_GL_TEXTURE_1D_ARRAY :: 0x8C18
GL30_GL_TEXTURE_2D_ARRAY :: 0x8C1A

/** Accepted by the {@code target} parameter of TexImage3D TexSubImage3D CopyTexSubImage3D CompressedTexImage3D and CompressedTexSubImage3D. */
 GL30_GL_PROXY_TEXTURE_2D_ARRAY :: 0x8C1B

/**
* Accepted by the {@code target} parameter of TexImage2D TexSubImage2D CopyTexImage2D CopyTexSubImage2D CompressedTexImage2D and
* CompressedTexSubImage2D.
*/
 GL30_GL_PROXY_TEXTURE_1D_ARRAY :: 0x8C19

/** Accepted by the {@code pname} parameter of GetBooleanv GetDoublev GetIntegerv and GetFloatv. */

GL30_GL_TEXTURE_BINDING_1D_ARRAY :: 0x8C1C
GL30_GL_TEXTURE_BINDING_2D_ARRAY :: 0x8C1D
GL30_GL_MAX_ARRAY_TEXTURE_LAYERS :: 0x88FF

/**
* Accepted by the {@code internalformat} parameter of TexImage2D CopyTexImage2D and CompressedTexImage2D and the {@code format} parameter of
* CompressedTexSubImage2D.
*/

GL30_GL_COMPRESSED_RED_RGTC1        :: 0x8DBB
GL30_GL_COMPRESSED_SIGNED_RED_RGTC1 :: 0x8DBC
GL30_GL_COMPRESSED_RG_RGTC2         :: 0x8DBD
GL30_GL_COMPRESSED_SIGNED_RG_RGTC2  :: 0x8DBE

/** Accepted by the {@code internalFormat} parameter of TexImage1D TexImage2D TexImage3D CopyTexImage1D and CopyTexImage2D. */

GL30_GL_R8             :: 0x8229
GL30_GL_R16            :: 0x822A
GL30_GL_RG8            :: 0x822B
GL30_GL_RG16           :: 0x822C
GL30_GL_R16F           :: 0x822D
GL30_GL_R32F           :: 0x822E
GL30_GL_RG16F          :: 0x822F
GL30_GL_RG32F          :: 0x8230
GL30_GL_R8I            :: 0x8231
GL30_GL_R8UI           :: 0x8232
GL30_GL_R16I           :: 0x8233
GL30_GL_R16UI          :: 0x8234
GL30_GL_R32I           :: 0x8235
GL30_GL_R32UI          :: 0x8236
GL30_GL_RG8I           :: 0x8237
GL30_GL_RG8UI          :: 0x8238
GL30_GL_RG16I          :: 0x8239
GL30_GL_RG16UI         :: 0x823A
GL30_GL_RG32I          :: 0x823B
GL30_GL_RG32UI         :: 0x823C
GL30_GL_RG             :: 0x8227
GL30_GL_COMPRESSED_RED :: 0x8225
GL30_GL_COMPRESSED_RG  :: 0x8226

/** Accepted by the {@code format} parameter of TexImage3D TexImage2D TexImage3D TexSubImage1D TexSubImage2D TexSubImage3D and ReadPixels. */
 GL30_GL_RG_INTEGER :: 0x8228

/**
* Accepted by the {@code target} parameters of BindBuffer BufferData BufferSubData MapBuffer UnmapBuffer GetBufferSubData GetBufferPointerv
* BindBufferRange BindBufferOffset and BindBufferBase.
*/
 GL30_GL_TRANSFORM_FEEDBACK_BUFFER :: 0x8C8E

/** Accepted by the {@code param} parameter of GetIntegeri_v and GetBooleani_v. */

GL30_GL_TRANSFORM_FEEDBACK_BUFFER_START :: 0x8C84
GL30_GL_TRANSFORM_FEEDBACK_BUFFER_SIZE  :: 0x8C85

/**
* Accepted by the {@code param} parameter of GetIntegeri_v and GetBooleani_v and by the {@code pname} parameter of GetBooleanv
* GetDoublev GetIntegerv and GetFloatv.
*/
 GL30_GL_TRANSFORM_FEEDBACK_BUFFER_BINDING :: 0x8C8F

/** Accepted by the {@code bufferMode} parameter of TransformFeedbackVaryings. */

GL30_GL_INTERLEAVED_ATTRIBS :: 0x8C8C
GL30_GL_SEPARATE_ATTRIBS    :: 0x8C8D

/** Accepted by the {@code target} parameter of BeginQuery EndQuery and GetQueryiv. */

GL30_GL_PRIMITIVES_GENERATED                  :: 0x8C87
GL30_GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN :: 0x8C88

/**
* Accepted by the {@code cap} parameter of Enable Disable and IsEnabled and by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and
* GetDoublev.
*/
 GL30_GL_RASTERIZER_DISCARD :: 0x8C89

/** Accepted by the {@code pname} parameter of GetBooleanv GetDoublev GetIntegerv and GetFloatv. */

GL30_GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS :: 0x8C8A
GL30_GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS       :: 0x8C8B
GL30_GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS    :: 0x8C80

/** Accepted by the {@code pname} parameter of GetProgramiv. */

GL30_GL_TRANSFORM_FEEDBACK_VARYINGS           :: 0x8C83
GL30_GL_TRANSFORM_FEEDBACK_BUFFER_MODE        :: 0x8C7F
GL30_GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH :: 0x8C76

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
 GL30_GL_VERTEX_ARRAY_BINDING :: 0x85B5

/**
* Accepted by the {@code cap} parameter of Enable Disable and IsEnabled and by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and
* GetDoublev.
*/
 GL30_GL_FRAMEBUFFER_SRGB :: 0x8DB9