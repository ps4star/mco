package cm_blaze3d

import j_util "mco:java/util"

import cm_math "mco:extern/com_mojang/math"

PoseStack :: struct
{
	pose_stack: j_util.Deque(PSPose),
}

PoseStack_init :: proc(this: ^PoseStack)
{
	m4f: cm_math.Matrix4f
	m3f: cm_math.Matrix3f

	cm_math.Matrix4f_set_ident(&m4f)
	cm_math.Matrix3f_set_ident(&m3f)

	j_util.Deque_push_back(&this.pose_stack, PSPose_new(&m4f, &m3f))
}

PoseStack_new :: proc() -> (out: PoseStack)
{
	PoseStack_init(&out)
	return
}

PoseStack_push_pose :: proc(this: ^PoseStack)
{
	p_last := j_util.Deque_peek_back(&this.pose_stack)

	tmp_m4 := cm_math.Matrix4f_copy(&p_last.pose)
	tmp_m3 := cm_math.Matrix3f_copy(&p_last.normal)
	j_util.Deque_push_back(&this.pose_stack, PSPose_new(&tmp_m4, &tmp_m3))
}

PoseStack_get_last :: proc(this: ^PoseStack) -> (^PSPose)
{
	return j_util.Deque_peek_back(&this.pose_stack)
}

PoseStack_set_ident :: proc(this: ^PoseStack)
{
	pose := PoseStack_get_last(this)
	cm_math.Matrix4f_set_ident(&pose.pose)
	cm_math.Matrix3f_set_ident(&pose.normal)
}

PoseStack_translate :: proc(this: ^PoseStack, d1, d2, d3: f64)
{
	m4f := cm_math.Matrix4f_new()
	cm_math.Matrix4f_set_ident(&m4f)

	m3f := cm_math.Matrix3f_new()
	cm_math.Matrix3f_set_ident(&m3f)
}




PSPose :: struct
{
	pose: cm_math.Matrix4f,
	normal: cm_math.Matrix3f,
}

PSPose_init :: proc(this: ^PSPose, m4f: ^cm_math.Matrix4f, m3f: ^cm_math.Matrix3f)
{
	this.pose = m4f^
	this.normal = m3f^
}

PSPose_new :: proc(m4f: ^cm_math.Matrix4f, m3f: ^cm_math.Matrix3f) -> (this: PSPose)
{
	PSPose_init(&this, m4f, m3f)
	return
}