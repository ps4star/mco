package mc

// @FullyImplementedClass
Timer :: struct
{
	partial_tick: f32,
	tick_delta: f32,
	last_ms: i64,
	ms_per_tick: f32,
}

Timer_init :: proc(this: ^Timer, fps: f32, last_ms: i64)
{
	this.ms_per_tick = 1_000.0 / fps
	this.last_ms = last_ms
}

Timer_new :: #force_inline proc(fps: f32, last_ms: i64) -> (this: Timer)
{
	Timer_init(&this, fps, last_ms)
	return
}

Timer_new_instance :: #force_inline proc(fps: f32, last_ms: i64) -> (this: ^Timer)
{
	this = new(Timer)
	Timer_init(this, fps, last_ms)
	return
}

Timer_advance_time :: proc(this: ^Timer, n: i64) -> (int)
{
	this.tick_delta = f32(n - this.last_ms) / this.ms_per_tick
	this.last_ms = n
	this.partial_tick += this.tick_delta
	i := int(this.partial_tick)
	this.partial_tick -= f32(i)
	return i
}