package lang
import conf "mco:odin/conf"

RunnableRunProc :: #type proc(this: ^Runnable)
Runnable :: struct
{
	ptrs: [conf.RUNNABLE_MAX_ARGS]rawptr,
	i32s: [conf.RUNNABLE_MAX_ARGS]i32,
	f32s: [conf.RUNNABLE_MAX_ARGS]f32,
	run: RunnableRunProc,
}

Runnable_init :: proc(this: ^Runnable, run: RunnableRunProc)
{
	this.run = run
}

Runnable_new_instance :: #force_inline proc(run: RunnableRunProc) -> (this: ^Runnable)
{
	this = new(Runnable)
	Runnable_init(this, run)
	return
}