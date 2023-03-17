package cm_blaze3d
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

import global "mco:odin/global"
import conf "mco:odin/conf"

import j_misc "mco:java/misc"

import glfw "shared:OdinGLFW"

VideoModeRegexResult :: [dynamic]int
VideoMode_REGEX :: proc(s: string, loc := #caller_location) -> (out: VideoModeRegexResult, does_match: bool)
{
	out = make([dynamic]int, 0, 4, context.temp_allocator)

	p_phase: uint = 1
	buf := strings.builder_make()

	does_match = true
	for i := 0; i < len(s); i += 1
	{
		this_char := s[i]
		switch p_phase {
		case 1:
			if this_char >= '0' && this_char <= '9'
			{
				strings.write_byte(&buf, this_char)
				break
			} else if this_char == 'x'
			{
				// Has gathered W, so write and advance
				append(&out, j_misc.string_to_int_with_assert(buf, loc))

				p_phase += 1
				strings.builder_reset(&buf)
				break
			} else
			{
				does_match = false
				panic(fmt.tprintln("Invalid character found in match string in VideoMode_REGEX call. Location:", loc))
			}

		case 2:
			if this_char >= '0' && this_char <= '9'
			{
				strings.write_byte(&buf, this_char)
				break
			} else if this_char == '@'
			{
				// Moving to 3rd phase
				append(&out, j_misc.string_to_int_with_assert(buf, loc))

				p_phase += 1
				strings.builder_reset(&buf)
				break
			} else
			{
				does_match = false
				panic(fmt.tprintln("Invalid character found in match string in VideoMode_REGEX call. Location:", loc))
			}

		case 3:
			if this_char >= '0' && this_char <= '9'
			{
				strings.write_byte(&buf, this_char)
				break
			} else if this_char == ':'
			{
				append(&out, j_misc.string_to_int_with_assert(buf, loc))

				p_phase += 1
				strings.builder_reset(&buf)
				break
			} else
			{
				does_match = false
				panic(fmt.tprintln("Invalid character found in match string in VideoMode_REGEX call. Location:", loc))
			}

		case 4:
			if this_char >= '0' && this_char <= '9'
			{
				strings.write_byte(&buf, this_char)
				break
			} else
			{
				does_match = false
				panic(fmt.tprintln("Invalid character found in match string in VideoMode_REGEX call. Location:", loc))
			}
		}
	}

	append(&out, j_misc.string_to_int_with_assert(buf, loc))
	strings.builder_reset(&buf)
	return
}

VideoMode :: glfw.VidMode
VideoMode_read :: proc(s: string) -> (Maybe(VideoMode))
{
	if len(s) == 0
	{
		return nil
	}

	res, matches := VideoMode_REGEX(s)
	if matches
	{
		i := res[0]
		j := res[1]

		third := res[2] if len(res) > 2 else -1
		if third == -1
		{
			third = 60
		}

		s1 := res[3] if len(res) > 3 else -1
		l: int
		if s1 == -1
		{
			l = 24
		} else
		{
			l = s1
		}

		i1: int = l / 3
		return cast(Maybe(VideoMode)) VideoMode{
			width = i32(i), height = i32(j),
			red_bits = i32(i1), green_bits = i32(i1), blue_bits = i32(i1),
			refresh_rate = i32(third),
		}
	}
	return nil
}

VideoMode_equals :: proc(this, v2: ^VideoMode) -> (bool)
{
	if this == v2
	{
		return true
	} else if v2 != nil
	{
		return this.width == v2.width &&
			this.height == v2.height &&
			this.red_bits == v2.red_bits &&
			this.green_bits == v2.green_bits &&
			this.blue_bits == v2.blue_bits &&
			this.refresh_rate == v2.refresh_rate
	} else
	{
		return false
	}
}