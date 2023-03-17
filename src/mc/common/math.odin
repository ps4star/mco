package mc_common
import "core:fmt"
import "core:strings"

import global "mco:odin/global"
import conf "mco:odin/conf"

Vec3 :: [3]f64

SmoothF64 :: struct
{
	target, remain, last: f64,
}

ceil :: proc(f: f32) -> (int)
{
	i := cast(int) f
	return f > f32(i) ? (i + 1) : i
}

// float f = 0.5F * p_14196_;
// int i = Float.floatToIntBits(p_14196_);
// i = 1597463007 - (i >> 1);
// p_14196_ = Float.intBitsToFloat(i);
// return p_14196_ * (1.5F - f * p_14196_ * p_14196_);
fast_inv_sqrt :: proc(f: f32) -> (f32)
{
	f := f
	_f := 0.5 * f
	i: i32 = transmute(i32) f
	i = 1597463007 - (i >> 1)
	f = transmute(f32) i

	return f * (1.5 - (_f * f * f))
}

lerp :: proc(f0, f1, f2: f32) -> (f32)
{
	return f1 + f0 * (f2 - f1)
}