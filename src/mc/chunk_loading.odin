package mc

// @DirectInterfaceImplementation
ChunkProgressListener :: struct
{
	update_spawn_pos: proc(this: rawptr, chunk_pos: ChunkPos),
	on_status_change: proc(this: rawptr, chunk_pos: ChunkPos, chunk_status: ^ChunkStatus),
	start: proc(this: rawptr),
	stop: proc(this: rawptr),
}
ChunkProgressListenerFactoryProc :: #type proc(int) -> (^ChunkProgressListener)

