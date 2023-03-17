package odin_global
import "core:intrinsics"

// Returns a proc that checks a nullable (_nil: bool) struct for being nil
procgen_nil_check :: proc($T: typeid) -> (proc(T) -> (bool))
	where intrinsics.type_has_field(T, "_nil")
{
	return #force_inline proc(n: T) -> (bool)
	{
		when intrinsics.type_is_pointer(T) {
			return n == nil
		} else {
			return n._nil
		}
	}
}