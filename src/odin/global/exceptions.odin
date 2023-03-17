package odin_global
import "core:fmt"
import "core:runtime"

import "mco:odin/conf"

// must not exceed 128 entries
ExceptionType :: enum
{
	Throwable,
	Exception,
	RuntimeException,
	SilentInitException,
	IllegalStateException,
	IllegalArgumentException,
	UnsupportedOperationException,
	InterruptedException,
	StackOverflowError,
	OutOfMemoryError,
}
ExceptionTypeSet :: bit_set[ExceptionType]

Exception :: struct
{
	type_set: ExceptionTypeSet,
	msg: string,
	loc: runtime.Source_Code_Location,
	// active: bool,
}

when conf.UNBOUNDED_EXCEPTION_STACK == conf.YES {
	@(private="file")
	ExceptionRecord :: struct
	{
		list: [dynamic]Exception,
		istack: [dynamic]int,
		c_top: int,
		c_base: int,
		c_istack_index: int,
	}
} else when conf.UNBOUNDED_EXCEPTION_STACK == conf.NO {
	@(private="file")
	ExceptionRecord :: struct
	{
		list: [conf.EXCEPTION_STACK_SIZE]Exception,
		istack: [conf.EXCEPTION_STACK_SIZE]int,
		c_top: int,
		c_base: int,
		c_istack_index: int,
	}
} else {
	#panic(conf.PANIC_MSG + "UNBOUNDED_EXCEPTION_STACK != YES|NO")
}

@(private="file", thread_local)
g_exceptions: ExceptionRecord

@(private="file", thread_local)
g_last_caught: Exception

/*@(private="file")
chstack :: #force_inline proc(ch_top, ch_base, ch_istack_index: int)
{
	g_exceptions.c_top += ch_top
	g_exceptions.c_base += ch_base
	g_exceptions.c_istack_index += ch_istack_index
}*/

throw :: proc(type_set: ExceptionTypeSet, msg: string = "", loc := #caller_location)
{
	tval := ExceptionTypeSet{ .Throwable, .Exception } // all exceptions are at least .Throwable and .Exception
	tval += type_set

	new_ex := Exception{ type_set = tval, msg = msg, loc = loc }
	when conf.UNBOUNDED_EXCEPTION_STACK == conf.YES {
		append(&g_exceptions.list, new_ex)
	} else {
		g_exceptions.list[g_exceptions.c_top] = new_ex
	}
	g_exceptions.c_top += 1
}

throw_unchecked :: #force_inline proc(type_set: ExceptionTypeSet, msg: string = "", loc := #caller_location)
{
	throw(type_set, msg, loc)
	check()
}

check :: proc()
{
	if g_exceptions.c_top != g_exceptions.c_base {
		fmt.println("FATAL: Uncaught exception(s) found during check.")
		fmt.println("EXCEPTION LIST: ", g_exceptions)
		// j_lang.Thread_panic()
	}
}

// Removes exception from stack if found in local frame, and also returns true if this happens
// Otherwise does nothing and returns false
catch :: proc(type_set: ExceptionTypeSet) -> (bool)
{
	i := g_exceptions.c_base
	for i < g_exceptions.c_top {
		e := g_exceptions.list[i]

		// A little tricky to explain this
		// If the "catching" type set and the current exception's type set share at least 1 element in common,
		// then we know that we have a match and should remove the exception
		cond := ((type_set & e.type_set) != {})
		if cond {
			// fmt.println("EXCEPTION CAUGHT: ", e)
			g_last_caught = e
			when conf.UNBOUNDED_EXCEPTION_STACK == conf.YES {
				ordered_remove(&g_exceptions.list, i)
			}

			g_exceptions.c_top -= 1
			return true
		}
		i += 1
	}

	// check_exceptions()
	return false
}

last_caught :: proc() -> (^Exception)
{
	return &g_last_caught
}

/*clear_all_exceptions :: #force_inline proc()
{
	clear(&g_exceptions.list)
}*/

push_exception_frame :: proc()
{
	ge := &g_exceptions
	_len := len(ge.list)

	when conf.UNBOUNDED_EXCEPTION_STACK == conf.YES {
		append(&ge.list, Exception{})
		append(&ge.istack, 0)
	}

	ge.istack[ge.c_istack_index] = _len
	ge.c_istack_index += 1
	ge.c_top = _len
	ge.c_base = _len
}

pop_exception_frame :: proc()
{
	ge := &g_exceptions

	when conf.UNBOUNDED_EXCEPTION_STACK == conf.YES {
		pop(&ge.list)
		pop(&ge.istack)
	}

	ge.c_istack_index -= 1
	ge.c_base = ge.istack[ge.c_istack_index]
	ge.c_top = ge.c_base
}