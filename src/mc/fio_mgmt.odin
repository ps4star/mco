package mc
import global "mco:odin/global"
import j_io "mco:java/io"

// Implemented by writing file with name ".lock.${name}" in same dir as locked file
DIR_LOCK_FILE_NAME := "session.lock"
FileLock :: struct
{
	lock_file: j_io.File,
}

DirectoryLock :: struct
{
	lock_file: j_io.File,
}

// @Static
DirectoryLock_create :: proc(path: string) -> (out: DirectoryLock)
{
	err := j_io.File_open(&(out.lock_file), global.join({ path, DIR_LOCK_FILE_NAME }))
	assert(err == j_io.ERROR_NONE)
	j_io.File_write_empty(&(out.lock_file))

	return
}