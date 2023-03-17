package cm_blaze3d
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"
import "core:mem"

import global "mco:odin/global"
import conf "mco:odin/conf"

import logging "mco:extern/com_mojang/logging"

VertexBuf :: struct {
	// IMPL
}

VertexBuf_unbind :: proc()
{
	BufferUploader_invalidate()
	GlStateManager_glBindVertexArray(0)
}





last_immediate_buf: ^VertexBuf
BufferUploader_reset :: proc()
{
	if last_immediate_buf != nil
	{
		BufferUploader_invalidate()
		VertexBuf_unbind()
	}
}

BufferUploader_invalidate :: proc()
{
	last_immediate_buf = nil
}




BufferBuilder :: struct
{
	buffer: [dynamic]byte,
	rendered_buffer_count: int,
	rendered_buffer_pointer: int,
	next_element_byte: int,
	vertices: int,

	current_element: VFmtElement,
	element_index: int,

	fast_format: bool,
	full_format: bool,
	building: bool,

	sorting_points: []global.Vector3f,
}

BufferBuilder_init :: proc(this: ^BufferBuilder, i: int)
{
	this.buffer = make([dynamic]byte, 0, i * 6)
}

BufferBuilder_begin :: proc(this: ^BufferBuilder, vfm: ^VFMode, vf: ^VFmt)
{
	
}

BufferBuilder_discard :: proc(this: ^BufferBuilder)
{
	this.rendered_buffer_count = 0
	this.rendered_buffer_pointer = 0
	this.next_element_byte = 0
}

BufferBuilder_clear :: proc(this: ^BufferBuilder)
{
	if this.rendered_buffer_count > 0
	{
		logging.log(.Warn, "Clearing BufferBuilder but unused batches present.")
	}

	BufferBuilder_discard(this)
}