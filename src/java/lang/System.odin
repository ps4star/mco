package lang
import odin_time "core:time"
import odin_os "core:os"

System_nano_time :: proc() -> (i64)
{
	return odin_time.to_unix_nanoseconds(odin_time.now())
}

System_exit :: proc(exit_code: int)
{
	odin_os.exit(exit_code)
}