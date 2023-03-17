package cm_math

Matrix3f :: matrix[3, 3]f32
Matrix4f :: matrix[4, 4]f32

Matrix3f_new :: #force_inline proc() -> (Matrix3f) { return Matrix3f{} }

Matrix4f_new_none :: #force_inline proc() -> (Matrix4f) { return Matrix4f{} }
Matrix4f_new_q :: proc(q: Quaternion) -> (out: Matrix4f)
{
	f := q.i
	f1 := q.j
	f2 := q.k
	f3 := q.r
	f4 := 2.0 * f * f
	f5 := 2.0 * f1 * f1
	f6 := 2.0 * f2 * f2
	out[0, 0] = 1.0 - f5 - f6
	out[1, 1] = 1.0 - f6 - f4
	out[2, 2] = 1.0 - f4 - f5
	out[3, 3] = 1.0
	f7 := f * f1
	f8 := f1 * f2
	f9 := f2 * f
	f10 := f * f3
	f11 := f1 * f3
	f12 := f2 * f3
	out[1, 0] = 2.0 * (f7 + f12)
	out[0, 1] = 2.0 * (f7 - f12)
	out[2, 0] = 2.0 * (f9 - f11)
	out[0, 2] = 2.0 * (f9 + f11)
	out[2, 1] = 2.0 * (f8 + f10)
	out[1, 2] = 2.0 * (f8 - f10)
	return
}
Matrix4f_new_m4f :: proc(other: Matrix4f) -> (out: Matrix4f)
{
	out[0, 0] = other[0, 0]
	out[0, 1] = other[0, 1]
	out[0, 2] = other[0, 2]
	out[0, 3] = other[0, 3]

	out[1, 0] = other[1, 0]
	out[1, 1] = other[1, 1]
	out[1, 2] = other[1, 2]
	out[1, 3] = other[1, 3]

	out[2, 0] = other[2, 0]
	out[2, 1] = other[2, 1]
	out[2, 2] = other[2, 2]
	out[2, 3] = other[2, 3]

	out[3, 0] = other[3, 0]
	out[3, 1] = other[3, 1]
	out[3, 2] = other[3, 2]
	out[3, 3] = other[3, 3]
	return
}
Matrix4f_new :: proc{
	Matrix4f_new_none,
	Matrix4f_new_q,
	Matrix4f_new_m4f,
}

Matrix3f_copy :: proc(this: ^Matrix3f) -> (Matrix3f) { out: Matrix3f; out = this^; return out }
Matrix4f_copy :: proc(this: ^Matrix4f) -> (Matrix4f) { out: Matrix4f; out = this^; return out }

Matrix4f_set_ident :: proc(m: ^matrix[4, 4]f32)
{
	m^[0, 0] = 1.0
	m^[0, 1] = 0.0
	m^[0, 2] = 0.0
	m^[0, 3] = 0.0

	m^[1, 0] = 0.0
	m^[1, 1] = 1.0
	m^[1, 2] = 0.0
	m^[1, 3] = 0.0

	m^[2, 0] = 0.0
	m^[2, 1] = 0.0
	m^[2, 2] = 1.0
	m^[2, 3] = 0.0

	m^[3, 0] = 0.0
	m^[3, 1] = 0.0
	m^[3, 2] = 0.0
	m^[3, 3] = 1.0
}

Matrix3f_set_ident :: proc(m: ^matrix[3, 3]f32)
{
	m^[0, 0] = 1.0
	m^[0, 1] = 0.0
	m^[0, 2] = 0.0

	m^[1, 0] = 0.0
	m^[1, 1] = 1.0
	m^[1, 2] = 0.0

	m^[2, 0] = 0.0
	m^[2, 1] = 0.0
	m^[2, 2] = 1.0
}

/*matrix_set_ident :: proc(m: ^matrix[$N, $N2]f32)
{
	when N :=:= 3 && N2 :=:= 3
	{
		#force_inline matrix3f_set_ident(m)
	} else when N :=:= 4 && N2 :=:= 4
	{
		#force_inline matrix4f_set_ident(m)
	} else
	{
		#panic("<cm_math>.matrix_set_ident only valid for 3x3 or 4x4 square matrices")
	}
}*/

Matrix4f_orthographic_4f :: proc(f1, f2, f3, f4: f32) -> (Matrix4f)
{
	m4f := Matrix4f_new()
	m4f[0, 0] = 2.0 / f1
	m4f[1, 1] = 2.0 / f2

	f := f4 - f3
	m4f[2, 2] = -2.0 / f
	m4f[3, 3] = 1.0
	m4f[0, 3] = -1.0
	m4f[1, 3] = 1.0
	m4f[2, 3] = -(f4 + f3) / f
	return m4f
}
Matrix4f_orthographic_6f :: proc(f1, f2, f3, f4, f5, f6: f32) -> (Matrix4f)
{
	m4f := Matrix4f_new()
	_f := f2 - f1
	_f1 := f3 - f4
	_f2 := f6 - f5
	m4f[0, 0] = 2.0 / _f
	m4f[1, 1] = 2.0 / _f1
	m4f[2, 2] = -2.0 / _f2
	m4f[0, 3] = -(f2 + f1) / _f
	m4f[1, 3] = -(f3 + f4) / _f1
	m4f[2, 3] = -(f6 + f5) / _f2
	m4f[3, 3] = 1.0
	return m4f
}
Matrix4f_orthographic :: proc{
	Matrix4f_orthographic_4f,
	Matrix4f_orthographic_6f,
}

Matrix4f_translate :: proc(this: ^matrix[4, 4]f32, v3f: Vector3f)
{
	this^[0, 3] += v3f.x
	this^[1, 3] += v3f.y
	this^[2, 3] += v3f.z
}

Matrix4f_create_scale :: proc(f1, f2, f3: f32) -> (Matrix4f)
{
	m4f := Matrix4f_new()
	m4f[0, 0] = f1
	m4f[1, 1] = f2
	m4f[2, 2] = f3
	m4f[3, 3] = 1.0
	return m4f
}

Matrix4f_create_translate :: proc(f1, f2, f3: f32) -> (Matrix4f)
{
	m4f := Matrix4f_new()
	m4f[0, 0] = 1.0
	m4f[1, 1] = 1.0
	m4f[2, 2] = 1.0
	m4f[3, 3] = 1.0

	m4f[0, 3] = f1
	m4f[1, 3] = f2
	m4f[2, 3] = f3
	return m4f
}

Matrix4f_multiply_m4f :: proc(this: ^Matrix4f, other: Matrix4f)
{
	f := this^[0, 0] * other[0, 0] + this^[0, 1] * other[1, 0] + this^[0, 2] * other[2, 0] + this^[0, 3] * other[3, 0]
	f1 := this^[0, 0] * other[0, 1] + this^[0, 1] * other[1, 1] + this^[0, 2] * other[2, 1] + this^[0, 3] * other[3, 1]
	f2 := this^[0, 0] * other[0, 2] + this^[0, 1] * other[1, 2] + this^[0, 2] * other[2, 2] + this^[0, 3] * other[3, 2]
	f3 := this^[0, 0] * other[0, 3] + this^[0, 1] * other[1, 3] + this^[0, 2] * other[2, 3] + this^[0, 3] * other[3, 3]
	f4 := this^[1, 0] * other[0, 0] + this^[1, 1] * other[1, 0] + this^[1, 2] * other[2, 0] + this^[1, 3] * other[3, 0]
	f5 := this^[1, 0] * other[0, 1] + this^[1, 1] * other[1, 1] + this^[1, 2] * other[2, 1] + this^[1, 3] * other[3, 1]
	f6 := this^[1, 0] * other[0, 2] + this^[1, 1] * other[1, 2] + this^[1, 2] * other[2, 2] + this^[1, 3] * other[3, 2]
	f7 := this^[1, 0] * other[0, 3] + this^[1, 1] * other[1, 3] + this^[1, 2] * other[2, 3] + this^[1, 3] * other[3, 3]
	f8 := this^[2, 0] * other[0, 0] + this^[2, 1] * other[1, 0] + this^[2, 2] * other[2, 0] + this^[2, 3] * other[3, 0]
	f9 := this^[2, 0] * other[0, 1] + this^[2, 1] * other[1, 1] + this^[2, 2] * other[2, 1] + this^[2, 3] * other[3, 1]
	f10 := this^[2, 0] * other[0, 2] + this^[2, 1] * other[1, 2] + this^[2, 2] * other[2, 2] + this^[2, 3] * other[3, 2]
	f11 := this^[2, 0] * other[0, 3] + this^[2, 1] * other[1, 3] + this^[2, 2] * other[2, 3] + this^[2, 3] * other[3, 3]
	f12 := this^[3, 0] * other[0, 0] + this^[3, 1] * other[1, 0] + this^[3, 2] * other[2, 0] + this^[3, 3] * other[3, 0]
	f13 := this^[3, 0] * other[0, 1] + this^[3, 1] * other[1, 1] + this^[3, 2] * other[2, 1] + this^[3, 3] * other[3, 1]
	f14 := this^[3, 0] * other[0, 2] + this^[3, 1] * other[1, 2] + this^[3, 2] * other[2, 2] + this^[3, 3] * other[3, 2]
	f15 := this^[3, 0] * other[0, 3] + this^[3, 1] * other[1, 3] + this^[3, 2] * other[2, 3] + this^[3, 3] * other[3, 3]

	this^[0, 0] = f
	this^[0, 1] = f1
	this^[0, 2] = f2
	this^[0, 3] = f3
	this^[1, 0] = f4
	this^[1, 1] = f5
	this^[1, 2] = f6
	this^[1, 3] = f7
	this^[2, 0] = f8
	this^[2, 1] = f9
	this^[2, 2] = f10
	this^[2, 3] = f11
	this^[3, 0] = f12
	this^[3, 1] = f13
	this^[3, 2] = f14
	this^[3, 3] = f15
}
Matrix4f_multiply_q :: proc(this: ^Matrix4f, q: Quaternion)
{
	Matrix4f_multiply_m4f(this, Matrix4f_new(q))
}
Matrix4f_multiply :: proc{
	Matrix4f_multiply_m4f,
	Matrix4f_multiply_q,
}