package serialization

import "mco:odin/global"

Lifecycle_STABLE := Lifecycle_new(proc(this: rawptr) -> (string)
{
	return "Stable"
})

Lifecycle_EXPERIMENTAL := Lifecycle_new(proc(this: rawptr) -> (string)
{
	return "Experimental"
})

@private ToStringProc :: #type proc(rawptr) -> (string)

Lifecycle :: struct {
	using _: global.InstanceComparable,
	to_string: ToStringProc,
}

Lifecycle_new_to_string :: proc(to_string: ToStringProc) -> (this: Lifecycle)
{
	this.to_string = to_string
	return
}

@(private="file")
Lifecycle_new_default :: proc() -> (this: Lifecycle)
{
	return
}

Lifecycle_new :: proc{ Lifecycle_new_to_string, Lifecycle_new_default }

	Deprecated :: struct {
		using lc: Lifecycle,
		since: int,
	}

	Deprecated_new :: proc(since: int) -> (this: Deprecated)
	{
		this.since = since
		return
	}

	Deprecated_since :: proc(this: ^Deprecated) -> (int)
	{
		return this.since
	}

Lifecycle_experimental :: proc() -> (^Lifecycle)
{
	return &Lifecycle_EXPERIMENTAL
}

Lifecycle_stable :: proc() -> (^Lifecycle)
{
	return &Lifecycle_STABLE
}

// MEMLEAK
Lifecycle_deprecated :: proc(since: int) -> (^Lifecycle)
{
	dep := new(Deprecated)
	dep^ = Deprecated_new(since)
	return dep
}