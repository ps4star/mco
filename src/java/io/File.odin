package java_io
import "core:fmt"
import odin_os "core:os"

import "mco:odin/global"

Errno :: odin_os.Errno
ERROR_NONE :: odin_os.ERROR_NONE

@private
assert_no_open_err :: #force_inline proc(err: Errno)
{
	assert(!(int(err) > 0), fmt.aprintf("Error in File_open call."))
}

File :: struct {
	odin_handle: odin_os.Handle,
	path: string,
}
File_open_from_path :: proc(f: ^File, path: string, mode: int = odin_os.O_RDWR, perm: int = 0) -> (Errno)
{
	err: Errno
	f.odin_handle, err = odin_os.open(path, mode, perm)
	f.path = path
	return err
}
File_open_parent_child :: proc(f: ^File, parent: ^File, child: string, mode: int = odin_os.O_RDWR, perm: int = 0) -> (Errno)
{
	assert(parent != nil)
	return #force_inline File_open_str_parent_child(f, parent.path, child, mode, perm)
}
File_open_str_parent_child :: proc(f: ^File, parent, child: string, mode: int = odin_os.O_RDWR, perm: int = 0) -> (Errno)
{
	assert(f != nil)
	err: Errno
	joined_path := global.join({ parent, child })
	defer if len(f.path) > 0 { delete(f.path) }

	f.odin_handle, err = odin_os.open(joined_path, mode, perm)
	f.path = joined_path
	return err
}
File_open :: proc{
	File_open_from_path,
	File_open_str_parent_child,
	File_open_parent_child,
}

File_write_empty :: #force_inline proc(f: ^File)
{
	odin_os.write_string(f.odin_handle, "")
}