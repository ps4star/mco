package mc

Input :: struct
{
	left_impulse: f32,
	forward_impulse: f32,

	up, down, left, right: bool,
	jumping: bool,

	shift_key_down: bool,
}