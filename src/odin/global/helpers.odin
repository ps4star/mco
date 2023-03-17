package odin_global

ToString :: #type proc(this: rawptr) -> (string)
// AbstractVoidConstructor :: #type proc(this: rawptr)

// Allows a struct to have a procgen_nil_check p-method
Nilable :: struct
{
	_nil: bool,
}

is_nilable_nil :: #force_inline proc(n: Nilable) -> (bool)
{
	return n._nil
}

// Sets up a struct so that it ensures it is nil
is_nil :: #force_inline proc(st: $N)
{
	st._nil = true
}

not_nil :: #force_inline proc(st: $N)
{
	st._nil = false
}

/*TypeTracked :: struct {
	_type: typeid,
}

set_type :: #force_inline proc(obj: ^$T, t: typeid)
{
	obj._type = t
}*/

InstanceComparable :: struct
{
	instanceof: typeid,
}

instanceof :: #force_inline proc(n: ^InstanceComparable, t_comp: typeid) -> (bool)
{
	return n.instanceof == t_comp
}