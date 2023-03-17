package mc
import "core:fmt"

import global "mco:odin/global"
import j_lang "mco:java/lang"
import j_concur "mco:java/util/concurrent"

import cm_log "mco:extern/com_mojang/logging"

import "core:intrinsics"

BlockableEventLoop :: struct($T: typeid) // <T extends Runnable>
	where !intrinsics.type_is_pointer(T)
{
	should_run: proc(this: ^BlockableEventLoop(T), item: ^T) -> (bool),
	pending_runnables: j_concur.ConcurrentLinkedQueue(T),
	blocking_count: int,
}

BlockableEventLoop_run_all_tasks :: proc(this: ^BlockableEventLoop($T), loc := #caller_location)
{
	for BlockableEventLoop_poll_task(this, loc) {}
}

BlockableEventLoop_poll_task :: proc(this: ^BlockableEventLoop($T), loc := #caller_location) -> (bool)
{
	if j_concur.ConcurrentLinkedQueue_len(this.pending_runnables) < 1
	{
		return false
	}

	item := j_concur.ConcurrentLinkedQueue_peek_front(&(this.pending_runnables))

	if item == nil {
		return false
	} else if this.blocking_count == 0 && !this->should_run(item) {
		return false
	} else {
		last_item := j_concur.ConcurrentLinkedQueue_peek_front(&(this.pending_runnables))
		BlockableEventLoop_do_run_task(this, last_item)

		_, worked := j_concur.ConcurrentLinkedQueue_pop_front(&(this.pending_runnables))
		assert(worked, /*fmt.aprintf*/("Attempt to pop ConcurrentLinkedQueue failed in: BlockableEventLoop_poll_task"))
		return true
	}
}

BlockableEventLoop_do_run_task :: proc(this: ^BlockableEventLoop($T), item: ^T)
{
	global.push_exception_frame()
	defer { global.check(); global.pop_exception_frame() }

	item->run()

	if global.catch({ .Exception }) {
		err_str := fmt.aprintln("Error executing task:", item, "\non <T extends Runnable>:", this, "\nException :::", global.last_caught())
		cm_log.log(.Fatal, err_str)
	}
}

ReentrantBlockableEventLoop :: struct($T: typeid) // <T extends Runnable>
{
	bl_evtloop: BlockableEventLoop(T),
	reentrant_count: int,
}

