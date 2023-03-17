package concurrent
import oq "core:container/queue"

/*
NOTE: NOT ACTUALLY THREAD-SAFE OR CONCURRENT AT ALL! (i don't think)

However I don't think it really matters anyway.
We're gonna de-multithread everything eventually
*/
ConcurrentLinkedQueue :: oq.Queue
ConcurrentLinkedQueue_init :: oq.init
ConcurrentLinkedQueue_len :: oq.len
ConcurrentLinkedQueue_peek_front :: oq.peek_front
ConcurrentLinkedQueue_peek_back :: oq.peek_back
ConcurrentLinkedQueue_pop_front :: oq.pop_front_safe
ConcurrentLinkedQueue_pop_back :: oq.pop_back_safe
ConcurrentLinkedQueue_add :: oq.append_elem

/*
import "mco:odin/global"

import j_util "../../util"

// @DifferingImplementation
// A linked queue is supposed to be a linked list normally
// Here, it is implemented as a linear stack with a manually-managed pointer
// That is, the head is not len() of a [dynamic]EntryT, but an int value
// on the struct itself.
ConcurrentLinkedQueue :: struct($T: typeid)
{
	_q: oq.Queue(T),
}

ConcurrentLinkedQueue_peek_front :: proc(this: ^ConcurrentLinkedQueue($T)) -> (T)
{
	return this._q
}*/