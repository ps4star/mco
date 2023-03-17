package java_io
import "core:slice"
import "core:intrinsics"

// Represents an output stream
DataOutput :: [dynamic]u8

write_slice :: proc(this: ^DataOutput, buf: []u8)
{
	for i in 0..<len(buf) { append(this, buf[i]) }
}

write_numeric :: proc(this: ^DataOutput, i: $T)
	where intrinsics.type_is_numeric(T)
{
	i := i
	/*as_mp := transmute([^]u8) &i*/
	as_sl := slice.from_ptr(transmute(^u8) &i, size_of(T))
	#assert(type_of(as_sl) == []u8)
	append(this, ..as_sl)
}