package odin_global
import "../conf"
import "core:intrinsics"

Vector3f :: #simd[4]f32

// Checks if float is near within tolerance
float_is_near :: proc(f: $T, near: $T2) -> (bool)
	where intrinsics.type_is_float(T),
	intrinsics.type_is_float(T2)
{
	return (f - T(conf.FLOAT_EQUIV_TOLERANCE)) <= near && (f + T(conf.FLOAT_EQUIV_TOLERANCE)) >= near
}