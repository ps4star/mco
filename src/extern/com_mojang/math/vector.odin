package cm_math

import mc_common "mco:mc/common"

Vector2f :: [2]f32
Vector3f :: [3]f32
Vector4f :: [4]f32

Vector2f_new :: #force_inline proc(f1, f2: f32) -> (Vector2f) { return { f1, f2 } }

Vector3f_new_none :: #force_inline proc() -> (Vector3f) { return {} }
Vector3f_new_direct :: #force_inline proc(f1, f2, f3: f32) -> (Vector3f) { return { f1, f2, f3 } }
Vector3f_new_vec4 :: proc(vec4: ^Vector4f) -> (Vector3f)
{
	return Vector3f_new_direct(vec4^[0], vec4^[1], vec4^[2])
}
Vector3f_new_phys_vec3 :: proc(vec3: ^mc_common.Vec3) -> (Vector3f)
{
	return Vector3f_new_direct(f32(vec3^[0]), f32(vec3^[1]), f32(vec3^[2]))
}
Vector3f_new :: proc{
	Vector3f_new_none,
	Vector3f_new_direct,
	Vector3f_new_vec4,
	Vector3f_new_phys_vec3,
}

Vector4f_new_none :: #force_inline proc() -> (Vector4f) { return {} }
Vector4f_new_direct :: #force_inline proc(f1, f2, f3, f4: f32) -> (Vector4f) { return { f1, f2, f3, f4 } }
Vector4f_new_vec3 :: #force_inline proc(vec3: ^Vector3f) -> (Vector4f)
{
	return Vector4f_new_direct(vec3.x, vec3.y, vec3.z, 1.0)
}
Vector4f_new :: proc{
	Vector4f_new_none,
	Vector4f_new_direct,
	Vector4f_new_vec3,
}

Vector3f_XN: Vector3f = { -1.0, 0.0, 0.0 }
Vector3f_XP: Vector3f = { 1.0, 0.0, 0.0 }

Vector3f_YN: Vector3f = { 0.0, -1.0, 0.0 }
Vector3f_YP: Vector3f = { 0.0, 1.0, 0.0 }

Vector3f_ZN: Vector3f = { 0.0, 0.0, -1.0 }
Vector3f_ZP: Vector3f = { 0.0, 0.0, 1.0 }

Vector3f_ZERO: Vector3f = { 0.0, 0.0, 0.0 }

Vector3f_normalize :: proc(this: ^Vector3f) -> (bool)
{
	f := this.x*this.x + this.y*this.y + this.z*this.z
	if f64(f) < 1.0e-5
	{
		return false
	}

	f1 := mc_common.fast_inv_sqrt(f)
	this^[0] *= f1
	this^[1] *= f1
	this^[2] *= f1
	return true
}

Vector3f_rotation_degrees :: proc(this: ^Vector3f, f: f32) -> (out: Quaternion)
{
	Quaternion_init(&out, this, f, true)
	return
}

Vector4f_transform :: proc(this: ^Vector4f, trans: ^Matrix4f)
{
	f := this^[0]
	f1 := this^[1]
	f2 := this^[2]
	f3 := this^[3]

	this[0] = trans^[0, 0] * f + trans^[0, 1] * f1 + trans^[0, 2] * f2 + trans^[0, 3] * f3
	this[1] = trans^[1, 0] * f + trans^[1, 1] * f1 + trans^[1, 2] * f2 + trans^[1, 3] * f3
	this[2] = trans^[2, 0] * f + trans^[2, 1] * f1 + trans^[2, 2] * f2 + trans^[2, 3] * f3
	this[3] = trans^[3, 0] * f + trans^[3, 1] * f1 + trans^[3, 2] * f2 + trans^[3, 3] * f3
}