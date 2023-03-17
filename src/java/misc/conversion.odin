package j_misc
import global "mco:odin/global"
import conf "mco:odin/conf"

import "core:strings"
import "core:strconv"

// Wrapped class conversions

// @Static
// @LingeringAlloc (string)
int_to_string :: proc(i: int) -> (string)
{
	builder := strings.builder_make()
	strings.write_int(&builder, i)
	return strings.to_string(builder)
}