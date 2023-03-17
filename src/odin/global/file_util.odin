package odin_global
import "core:os"
import fp "core:path/filepath"

join :: fp.join
resolve :: #force_inline proc(path: string) -> (string)
{
	return join({ os.args[0], path })
}