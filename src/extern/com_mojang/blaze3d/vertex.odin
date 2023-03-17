package cm_blaze3d

VFmtElement :: struct
{
	index, count, byte_size: int,
}

VFmt :: struct
{
	
}





VFIndexType :: enum
{
	Byte,
	Short,
	Int,
}

VFIndexTypeValue :: struct
{
	as_gl_type, bytes: int,
}

VFIndexTypeValues := [VFIndexType]VFIndexTypeValue{
	.Byte = { 5121, 1 },
	.Short = { 5123, 2 },
	.Int = { 5125, 4 },
}

least_index :: proc(i: int) -> (VFIndexType)
{
	i := i32(i)
	if (i & -65536) != 0
	{
		return .Int
	}

	return .Short if ((i & 0xff00) != 0) else .Byte
}








// VertexFormat.Mode
VFMode :: enum
{
	Lines,
	LineStrip,
	DebugLines,
	DebugLineStrip,
	Triangles,
	TriangleStrip,
	TriangleFan,
	Quads,
}

VFModeValue :: struct
{
	as_gl_mode, prim_length, prim_stride: int,
	connected_prims: bool,
}

VFModeValues := [VFMode]VFModeValue{
	.Lines = { 4, 2, 2, false },
	.LineStrip = { 5, 2, 1, true },
	.DebugLines = { 1, 2, 2, false },
	.DebugLineStrip = { 3, 2, 1, true },
	.Triangles = { 4, 3, 3, false },
	.TriangleStrip = { 5, 3, 1, true },
	.TriangleFan = { 6, 3, 1, true },
	.Quads = { 4, 4, 4, false },
}

VFMode_index_count :: proc(m: VFMode, val: int) -> (int)
{
	i: int
	switch m
	{
	case .LineStrip, .DebugLines, .DebugLineStrip, .Triangles, .TriangleStrip, .TriangleFan:
		i = val
		break

	case .Lines, .Quads:
		i = val / 4 * 6
		break

	case:
		i = 0
	}

	return i
}