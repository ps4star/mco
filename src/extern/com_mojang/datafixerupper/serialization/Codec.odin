package serialization

import "mco:odin/global"

// Encoder<T>

/* NOTE ON ANY

While using the "any" type here is obviously not ideal,
there isn't really a better way to implement a generic codec.

The best thing would be to effect port later on, but for now
this should work.

TODO(ps4star): consider upgrading codec to effect port
*/
Encoder :: struct($T: typeid)
{
	to: proc "odin" (T) -> (any),
}

Decoder :: struct($T: typeid)
{
	from: proc "odin" (any) -> (T),
}

// Replacement for Codec<T>
Codec :: struct($T, $T2: typeid)
{
	r: proc(rawptr, T2) -> (T),
	w: proc(rawptr, T) -> (T2),
}