package odin_global
import "core:fmt"
import "core:strings"
import "core:mem"
import "core:runtime"

import conf "mco:odin/conf"

Allocator_Mode :: runtime.Allocator_Mode
Allocator_Error :: runtime.Allocator_Error
Allocator_Proc :: runtime.Allocator_Proc
Context :: runtime.Context

Allocator :: runtime.Allocator
// Source_Code_Location :: runtime.Source_Code_Location

// @UserImmutable
custom_context: Context

// NOTE: this defaults to same as ALLOC_TYPE when unspecified
when conf.TALLOC_TYPE == conf.MEM_DEBUG {
	#assert("NOT IMPL")
} else when conf.TALLOC_TYPE == conf.MEM_STD {
	Talloc :: runtime.Default_Temp_Allocator
	_custom_talloc_proc :: runtime.default_temp_allocator_proc
} else when conf.TALLOC_TYPE == conf.MEM_FAST {
	#panic("MEM_FAST NOT IMPL YET!")

	Talloc :: struct
	{
		start, head, end: uintptr,
	}

	_custom_talloc_init :: #force_inline proc(s: ^Talloc, size: int, allocator := context.allocator)
	{
		s.start = transmute(uintptr) mem.alloc(size=size, allocator=allocator)
		s.head = s.start
		s.end = s.start + uintptr(size)
	}

	_custom_talloc_alloc :: #force_inline proc(s: ^Talloc, size, align: int) -> (data: []byte, err: Allocator_Error)
	{
		new_aligned_head := s.head + uintptr(size + (size & (align-1)))
		if s.end > new_aligned_head { // normal case; return head ptr as it is now and 
			data = (transmute([^]byte) s.head)[:size]
			s.head = new_aligned_head
			return
		}

		/*if s.start + uintptr(size + align) >= s.end { // rare case; set head back to start or panic if alloc size is too big
			panic("Could not talloc data because size > talloc buf size. Please increase TALLOC_SIZE (recommended >=256KB).")
		}*/

		// fmt.println(s, size, align, s.end - s.start, new_aligned_head)
		assert(s.start + uintptr(size + align) >= s.end,
			"Could not talloc data because size > talloc buf size. Please increase TALLOC_SIZE (recommended >=512_000).")

		s.head = s.start
		data = (transmute([^]byte) s.head)[:size]
		return
	}

	_custom_talloc_resize :: #force_inline proc(s: ^Talloc, ptr: rawptr,
		old_size, size, align: int, loc := #caller_location) -> (data: []byte, err: Allocator_Error)
	{
		fmt.println(s, ptr, old_size, size, align, loc)
		assert(s.start + uintptr(size + align) < s.end)
		new_aligned_head := (transmute(uintptr) ptr) + uintptr(size + (size & (align-1)))
		mem.copy(transmute(rawptr) new_aligned_head, ptr, old_size)
		return _custom_talloc_alloc(s, size, align)
	}

	_custom_talloc_proc :: proc(allocator_data: rawptr, mode: Allocator_Mode,
		size, alignment: int,
		old_memory: rawptr, old_size: int,
		location := #caller_location) -> (data: []byte, err: Allocator_Error)
	{
		s := (^Talloc)(allocator_data)
		/*if s.data == nil {
			// default_temp_allocator_init(s, DEFAULT_TEMP_ALLOCATOR_BACKING_SIZE, default_allocator())
		}*/

		switch mode {
		case .Alloc:
			data, err = _custom_talloc_alloc(s, size, alignment)

		case .Free:
			fmt.println("FREE")

		case .Free_All:
			fmt.println("FREE_ALL")

		case .Resize:
			data, err = _custom_talloc_resize(s, old_memory, old_size, size, alignment, location)

		/*case .Resize:
			data, err = _custom_talloc_resize(s, old_memory, old_size, size, alignment)*/
			

		case .Query_Features, .Query_Info:
			panic("This custom talloc only accepts allocate and resize functionality! Free/Free_All and queries not accepted.")
		}

		return
	}
}

// Context mgmt
when conf.ALLOC_TYPE == conf.MEM_DEBUG {
	// IMPL
	#panic("ALLOC_TYPE == MEM_DEBUG IS NOT IMPLEMENTED!")
} else when conf.ALLOC_TYPE == conf.MEM_STD {
	// std odin context
	init_memory :: #force_inline proc(talloc_size: int, allocator := context.allocator)
	{
		// custom_context = #force_inline runtime.default_context()
		init_global_temporary_allocator(talloc_size)
	}
} else when conf.ALLOC_TYPE == conf.MEM_FAST {
	// fastest context
	#panic("MEM_FAST NOT IMPL YET!")

	// NOTE: for now we're keeping STD only for normal allocs;
	// tallocs will still be the custom thing though for now
	// TODO: IMPL custom alloc maybe + re-analyze this whole system
	@private g_talloc: Talloc
	_custom_alloc_proc :: runtime.default_allocator_proc
	init_memory :: #force_inline proc(talloc_size: int, allocator := context.allocator)
	{
		custom_context = #force_inline runtime.default_context()
		// custom_context.allocator.procedure = _custom_alloc_proc

		custom_context.temp_allocator.data = rawptr(&g_talloc)
		custom_context.temp_allocator.procedure = _custom_talloc_proc

		_custom_talloc_init((^Talloc)(custom_context.temp_allocator.data), talloc_size, allocator)
	}
}