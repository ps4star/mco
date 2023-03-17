package j_misc
import "core:fmt"
import "core:strings"
import "core:strconv"

Map_get_or_default :: #force_inline proc(m: map[$T]$N, k: T, default_value: N) -> (N)
{
	key, has_key := m[k]
	return default_value if !has_key else key
}

fill_fixed :: #force_inline proc(fixed_arr: ^[$N]$T, item: T)
{
	for i in fixed_arr
	{
		i = item
	}
}

fill_slice :: #force_inline proc(sl: []$T, item: T)
{
	for _, i in sl
	{
		sl[i] = item
	}
}

// str builder -> int with implicit assert
string_to_int_with_assert :: proc(sb: strings.Builder, loc := #caller_location) -> (int)
{
	val, worked := strconv.parse_int(strings.to_string(sb))
	assert(worked, fmt.tprintln("Location:", loc))
	return val
}