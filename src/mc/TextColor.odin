package mc
import "core:strings"

import cm_ser "mco_com_mojang:datafixerupper/serialization"

TextColor_CODEC := cm_ser.Codec(TextColor, string){}
TextColor :: struct
{
	value: int,
	name: string,
}

TextColor_parse :: proc(tc: ^TextColor) -> (string) // @TallocedReturn
{
	b := strings.builder_make_len_cap(0, 32, context.temp_allocator)
	// defer strings.builder_destroy(b) // not needed since tAlloc

	strings.write_int(&b, tc.value, 16)
	return strings.to_string(b)
}