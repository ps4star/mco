package lang
import "core:math"

import j_misc "mco:java/misc"

PI :: math.PI

Double_is_NaN :: #force_inline proc(d: f64) -> (bool)
{
	return d != d
}

Double_double_to_raw_long_bits :: #force_inline proc(d: f64) -> (i64)
{
	return transmute(i64) d
}

Double_long_bits_to_double :: #force_inline proc(i: i64) -> (f64)
{
	return transmute(f64) i
}

// @Static
copy_sign :: proc(mag, sign: f64) -> (f64)
{
	return Double_long_bits_to_double((Double_double_to_raw_long_bits(sign) & j_misc.LONG_MIN_VALUE) |
		(Double_double_to_raw_long_bits(mag) & j_misc.LONG_MAX_VALUE))
}

// @Static
signum :: proc(d: f64) -> (f64)
{
	return copy_sign(1.0, d) if (d != 0.0 && !Double_is_NaN(d)) else d
}