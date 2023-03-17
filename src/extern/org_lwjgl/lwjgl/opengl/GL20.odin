package opengl

/** Accepted by the {@code name} parameter of GetString. */
GL20_GL_SHADING_LANGUAGE_VERSION :: 0x8B8C

/** Accepted by the {@code pname} parameter of GetInteger. */
GL20_GL_CURRENT_PROGRAM :: 0x8B8D

/** Accepted by the {@code pname} parameter of GetShaderiv. */

GL20_GL_SHADER_TYPE                 :: 0x8B4F
GL20_GL_DELETE_STATUS               :: 0x8B80
GL20_GL_COMPILE_STATUS              :: 0x8B81
GL20_GL_LINK_STATUS                 :: 0x8B82
GL20_GL_VALIDATE_STATUS             :: 0x8B83
GL20_GL_INFO_LOG_LENGTH             :: 0x8B84
GL20_GL_ATTACHED_SHADERS            :: 0x8B85
GL20_GL_ACTIVE_UNIFORMS             :: 0x8B86
GL20_GL_ACTIVE_UNIFORM_MAX_LENGTH   :: 0x8B87
GL20_GL_ACTIVE_ATTRIBUTES           :: 0x8B89
GL20_GL_ACTIVE_ATTRIBUTE_MAX_LENGTH :: 0x8B8A
GL20_GL_SHADER_SOURCE_LENGTH        :: 0x8B88

/** Returned by the {@code type} parameter of GetActiveUniform. */

GL20_GL_FLOAT_VEC2        :: 0x8B50
GL20_GL_FLOAT_VEC3        :: 0x8B51
GL20_GL_FLOAT_VEC4        :: 0x8B52
GL20_GL_INT_VEC2          :: 0x8B53
GL20_GL_INT_VEC3          :: 0x8B54
GL20_GL_INT_VEC4          :: 0x8B55
GL20_GL_BOOL              :: 0x8B56
GL20_GL_BOOL_VEC2         :: 0x8B57
GL20_GL_BOOL_VEC3         :: 0x8B58
GL20_GL_BOOL_VEC4         :: 0x8B59
GL20_GL_FLOAT_MAT2        :: 0x8B5A
GL20_GL_FLOAT_MAT3        :: 0x8B5B
GL20_GL_FLOAT_MAT4        :: 0x8B5C
GL20_GL_SAMPLER_1D        :: 0x8B5D
GL20_GL_SAMPLER_2D        :: 0x8B5E
GL20_GL_SAMPLER_3D        :: 0x8B5F
GL20_GL_SAMPLER_CUBE      :: 0x8B60
GL20_GL_SAMPLER_1D_SHADOW :: 0x8B61
GL20_GL_SAMPLER_2D_SHADOW :: 0x8B62

/** Accepted by the {@code type} argument of CreateShader and returned by the {@code params} parameter of GetShaderiv. */
GL20_GL_VERTEX_SHADER :: 0x8B31

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL20_GL_MAX_VERTEX_UNIFORM_COMPONENTS    :: 0x8B4A
GL20_GL_MAX_VARYING_FLOATS               :: 0x8B4B
GL20_GL_MAX_VERTEX_ATTRIBS               :: 0x8869
GL20_GL_MAX_TEXTURE_IMAGE_UNITS          :: 0x8872
GL20_GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS   :: 0x8B4C
GL20_GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS :: 0x8B4D
GL20_GL_MAX_TEXTURE_COORDS               :: 0x8871

/**
* Accepted by the {@code cap} parameter of Disable Enable and IsEnabled and by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and
* GetDoublev.
*/

GL20_GL_VERTEX_PROGRAM_POINT_SIZE :: 0x8642
GL20_GL_VERTEX_PROGRAM_TWO_SIDE   :: 0x8643

/** Accepted by the {@code pname} parameter of GetVertexAttrib{dfi}v. */

GL20_GL_VERTEX_ATTRIB_ARRAY_ENABLED    :: 0x8622
GL20_GL_VERTEX_ATTRIB_ARRAY_SIZE       :: 0x8623
GL20_GL_VERTEX_ATTRIB_ARRAY_STRIDE     :: 0x8624
GL20_GL_VERTEX_ATTRIB_ARRAY_TYPE       :: 0x8625
GL20_GL_VERTEX_ATTRIB_ARRAY_NORMALIZED :: 0x886A
GL20_GL_CURRENT_VERTEX_ATTRIB          :: 0x8626

/** Accepted by the {@code pname} parameter of GetVertexAttribPointerv. */
GL20_GL_VERTEX_ATTRIB_ARRAY_POINTER :: 0x8645

/** Accepted by the {@code type} argument of CreateShader and returned by the {@code params} parameter of GetShaderiv. */
GL20_GL_FRAGMENT_SHADER :: 0x8B30

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
GL20_GL_MAX_FRAGMENT_UNIFORM_COMPONENTS :: 0x8B49

/** Accepted by the {@code target} parameter of Hint and the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */
GL20_GL_FRAGMENT_SHADER_DERIVATIVE_HINT :: 0x8B8B

/** Accepted by the {@code pname} parameters of GetIntegerv GetFloatv and GetDoublev. */

GL20_GL_MAX_DRAW_BUFFERS :: 0x8824
GL20_GL_DRAW_BUFFER0     :: 0x8825
GL20_GL_DRAW_BUFFER1     :: 0x8826
GL20_GL_DRAW_BUFFER2     :: 0x8827
GL20_GL_DRAW_BUFFER3     :: 0x8828
GL20_GL_DRAW_BUFFER4     :: 0x8829
GL20_GL_DRAW_BUFFER5     :: 0x882A
GL20_GL_DRAW_BUFFER6     :: 0x882B
GL20_GL_DRAW_BUFFER7     :: 0x882C
GL20_GL_DRAW_BUFFER8     :: 0x882D
GL20_GL_DRAW_BUFFER9     :: 0x882E
GL20_GL_DRAW_BUFFER10    :: 0x882F
GL20_GL_DRAW_BUFFER11    :: 0x8830
GL20_GL_DRAW_BUFFER12    :: 0x8831
GL20_GL_DRAW_BUFFER13    :: 0x8832
GL20_GL_DRAW_BUFFER14    :: 0x8833
GL20_GL_DRAW_BUFFER15    :: 0x8834

/**
* Accepted by the {@code cap} parameter of Enable Disable and IsEnabled by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and
* GetDoublev and by the {@code target} parameter of TexEnvi TexEnviv TexEnvf TexEnvfv GetTexEnviv and GetTexEnvfv.
*/
GL20_GL_POINT_SPRITE :: 0x8861

/**
* When the {@code target} parameter of TexEnvf TexEnvfv TexEnvi TexEnviv GetTexEnvfv or GetTexEnviv is POINT_SPRITE then the value of
* {@code pname} may be.
*/
GL20_GL_COORD_REPLACE :: 0x8862

/** Accepted by the {@code pname} parameter of PointParameter{if}v. */
GL20_GL_POINT_SPRITE_COORD_ORIGIN :: 0x8CA0

/** Accepted by the {@code param} parameter of PointParameter{if}v. */

GL20_GL_LOWER_LEFT :: 0x8CA1
GL20_GL_UPPER_LEFT :: 0x8CA2

/** Accepted by the {@code pname} parameter of GetBooleanv GetIntegerv GetFloatv and GetDoublev. */

GL20_GL_BLEND_EQUATION_RGB   :: 0x8009
GL20_GL_BLEND_EQUATION_ALPHA :: 0x883D

/** Accepted by the {@code pname} parameter of GetIntegerv. */

GL20_GL_STENCIL_BACK_FUNC            :: 0x8800
GL20_GL_STENCIL_BACK_FAIL            :: 0x8801
GL20_GL_STENCIL_BACK_PASS_DEPTH_FAIL :: 0x8802
GL20_GL_STENCIL_BACK_PASS_DEPTH_PASS :: 0x8803
GL20_GL_STENCIL_BACK_REF             :: 0x8CA3
GL20_GL_STENCIL_BACK_VALUE_MASK      :: 0x8CA4
GL20_GL_STENCIL_BACK_WRITEMASK       :: 0x8CA5