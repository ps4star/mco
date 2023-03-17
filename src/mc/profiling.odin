package mc
import global "mco:odin/global"
import conf "mco:odin/conf"

import j_io "mco:java/io"
import j_util "mco:java/util"
import j_util_func "mco:java/util/function"

ProfilerState :: enum
{
	Inactive,
	Active,
}

Profiler :: struct
{
	state: ProfilerState,

	// Active
	paths: [dynamic]string,
	get_tick_time: j_util_func.IntSupplier,
	get_real_time: j_util_func.LongSupplier,
	start_time_nano: i64,
	start_time_ticks: int,

	path: string,
	started: bool,
	// currentEntry: ,
	warn: bool,
}

InactiveProfiler_INST: ^Profiler

Profiling_INIT :: proc()
{
	InactiveProfiler_INST = new(Profiler)
	Profiler_init_inactive(InactiveProfiler_INST)
}

Profiler_init_inactive :: proc(this: ^Profiler)
{
	//init_common(this)
	this.state = .Inactive
}

Profiler_init_active :: proc(this: ^Profiler, lsup: j_util_func.LongSupplier, isup: j_util_func.IntSupplier, flag: bool)
{
	//init_common(this)
	this.state = .Active
	this.paths = make(type_of(this.paths))

	this.start_time_nano = lsup.get((rawptr)(this))
	this.get_real_time = lsup
	this.start_time_ticks = isup.get((rawptr)(this))
	this.get_tick_time = isup
	this.warn = flag

	this.path = ""
}

Profiler_push :: proc(this: ^Profiler, to_push: string)
{
	// Is ActiveProfiler
	if this.state == .Active {
		append(&(this.paths), to_push)
	}
}

// This is a COMPLETELY unrelated class to the above
SingleTickProfiler :: struct
{
	profiler: ^Profiler,
	real_time: j_util_func.LongSupplier,
	location: j_io.File,
	save_threshold: i64,
}

SingleTickProfiler_init :: proc(this: ^SingleTickProfiler, lsup: j_util_func.LongSupplier, relpath: string, l: i64)
{
	this.real_time = lsup
	j_io.File_open(&(this.location), "debug", relpath)
	this.save_threshold = l
}

// @Static
create_tick_profiler :: #force_inline proc(name: string) -> (^SingleTickProfiler)
{
	return (^SingleTickProfiler)(nil)
}

// Again, COMPLETELY unrelated to other profilers
ContinuousProfiler :: struct
{
	real_time: j_util_func.LongSupplier,
	tick_count: j_util_func.IntSupplier,

	profiler: ^Profiler,
}

ContinuousProfiler_init :: proc(this: ^ContinuousProfiler, lsup: j_util_func.LongSupplier, isup: j_util_func.IntSupplier)
{
	// Defaults
	this.profiler = InactiveProfiler_INST

	// ...
	this.real_time = lsup
	this.tick_count = isup
}

ContinuousProfiler_disable :: #force_inline proc(this: ^ContinuousProfiler)
{
	this.profiler = InactiveProfiler_INST
}

ContinuousProfiler_enable :: #force_inline proc(this: ^ContinuousProfiler)
{
	if this.profiler != nil && this.profiler.state != .Inactive && this.profiler != InactiveProfiler_INST {
		// Likely should be freed
		// @Reeval
		free(this.profiler)
	}

	this.profiler = new(Profiler)
	Profiler_init_active(this.profiler, this.real_time, this.tick_count, true)
}