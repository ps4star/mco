package cm_math
import "core:math"

PI :: math.PI

Quaternion :: struct
{
	i, j, k, r: f32,
}

Quaternion_init_1 :: proc(this: ^Quaternion, i, j, k, r: f32)
{
	this.i = i
	this.j = j
	this.k = k
	this.r = r
}
Quaternion_init_2 :: proc(this: ^Quaternion, v3f: ^Vector3f, r: f32, flag: bool)
{
	r := r
	if flag
	{
		r *= (f32(PI) / f32(180.0))
	}

	f := math.sin(r / f32(2.0))
	this.i = v3f^[0] * f
	this.j = v3f^[1] * f
	this.k = v3f^[2] * f
	this.r = math.cos(r / f32(2.0))
}
Quaternion_init_3 :: proc(this: ^Quaternion, f1, f2, f3: f32, b: bool)
{
	f1 := f1
	f2 := f2
	f3 := f3

	if b
	{
		f1 *= (f32(PI) / 180.0)
		f2 *= (f32(PI) / 180.0)
		f3 *= (f32(PI) / 180.0)
	}

	_f := math.sin(0.5 * f1)
	_f1 := math.cos(0.5 * f1)

	_f2 := math.sin(0.5 * f2)
	_f3 := math.cos(0.5 * f2)

	_f4 := math.sin(0.5 * f3)
	_f5 := math.cos(0.5 * f3)

	this.i = _f * _f3 * _f5 + _f1 * _f2 * _f4
	this.j = _f1 * _f2 * _f5 - _f * _f3 * _f4
	this.k = _f * _f2 * _f5 + _f1 * _f3 * _f4
	this.r = _f1 * _f3 * _f5 - _f * _f2 * _f4
}
Quaternion_init_4 :: proc(this: ^Quaternion, other: ^Quaternion)
{
	this.i = other.i
	this.j = other.j
	this.k = other.k
	this.r = other.r
}
Quaternion_init :: proc{
	Quaternion_init_1,
	Quaternion_init_2,
	Quaternion_init_3,
	Quaternion_init_4,
}