package lang
import "core:fmt"
import "core:strings"
import "core:os"
import th "core:thread"

// My own implementation of java.lang.Thread
// Needs to be able to, most importantly, keep records of what's going on with threads
// that have been dispatched.
// For example provide a current_thread() proc
// Odin threads cannot do this natively so we need to wrap them here,
// but really all of the leg work still goes to core:thread

OdinThread :: th.Thread
ThreadPriority :: th.Thread_Priority

ROOT_THREAD :: "main"

Thread :: struct
{
	name: string,
	running: bool,
	odin_thread: ^OdinThread,
}

@(private="file")
ThreadRecord :: struct
{
	threads: [dynamic]Thread,
	// thread_names: [dynamic]string,
	// index: string,
}

@(private="file")
main_thread := OdinThread{}

@(private="file")
active := ThreadRecord{}

@(private="file")
panic_hook: ^Thread = nil

Thread_new :: proc(name: string, tproc: th.Thread_Proc, prio := ThreadPriority.Normal) -> (^Thread)
{
	_th: Thread
	_th.name = name
	_th.odin_thread = th.create(tproc, prio)
	append(&active.threads, _th)
	return &active.threads[len(active.threads) - 1]
}

Thread_start :: #force_inline proc(this: ^Thread)
{
	this.running = true
	th.start(this.odin_thread)
}

Thread_join :: proc(this: ^Thread)
{
	this.running = false
	th.join(this.odin_thread)
}

// Thread_current_thread :: #force_inline proc() -> (^Thread)
// {
// 	return &active.threads[ROOT_THREAD]
// }

Thread_set_name :: #force_inline proc(this: ^Thread, new_name: string)
{
	this.name = new_name
}

// CUSTOM
Thread_get_by_name :: proc(name: string) -> (^Thread)
{
	for i in 0..<len(active.threads) {
		thr := &active.threads[i]
		if thr.name == name { return thr }
	}
	return nil
}

// CUSTOM
Thread_unwrap_odin_thread :: #force_inline proc(this: ^Thread) -> (^OdinThread)
{
	return this.odin_thread
}

// CUSTOM/REPLACEMENT
// We cannot have a currentThread() p-method here for various reasons
// but what we can do is have a proc that takes in the current thread (or nil)
// and return which thread you must be on
Thread_current_thread :: proc(loc := #caller_location) -> (^Thread)
{
	cid := os.current_thread_id()

	for i in 0..<len(active.threads) {
		athread := &active.threads[i]		
		if cid == athread.odin_thread.id {
			return athread
		}
	}

	Thread_print()
	fmt.println("CUR. ID: ", os.current_thread_id())
	fmt.println("CALLED FROM: ", loc)
	Thread_panic("Current thread could not be found!")
	return nil
}

// INIT
// Inits the "main" thread
// Apparently this doesn't work at file-scope since os.current_thread_id() returns 0 there
// So it must be called from main() to have proper behavior
// NOTE that the odin_thread field is not a valid OdinThread and simply is there to hold the id value of the main
// thread so that Thread_current_thread will actually work properly re: the main thread

	/*threads = [dynamic]Thread{
		{ name = ROOT_THREAD, odin_thread = &main_thread },
	},*/
Thread_INIT :: proc()
{
	ot := &main_thread
	ot.id = os.current_thread_id()

	active.threads = make(type_of(active.threads))
	append(&active.threads, Thread{ name = ROOT_THREAD, odin_thread = ot })
}

// CUSTOM/DEBUG
// Prints thread info
Thread_print :: proc()
{
	fmt.println(active)
}

// CUSTOM
// Grabs an argument off the local OdinThread
Thread_get_argument :: proc(local_thr: ^OdinThread, $arg: typeid) -> (arg)
{
	when arg == ^Thread {
		return transmute(^Thread) local_thr.user_args[0]
	}
}

// CUSTOM
// Hook for if exception causes a panic
Thread_set_panic_thread :: #force_inline proc(phook: ^Thread)
{
	panic_hook = phook
}

// CUSTOM
// Panic handler
Thread_panic :: proc(msg: string = "")
{
	if panic_hook != nil {
		Thread_start(panic_hook)
	}
	panic(msg)
}