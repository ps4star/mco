package j_misc
import global "mco:odin/global"
import conf "mco:odin/conf"
import j_io "mco:java/io"

// Some extra java implementations that don't fit in other files

// getResourceAsStream() replacement
// takes an absolute path and returns j_io.File

@private
resolve_n :: #force_inline proc(res_path: string, n: string) -> (string)
{
	tmp := global.join({ n, res_path }, context.temp_allocator)
	out := global.resolve(tmp)
	return out
}

resolve_jar_resource :: #force_inline proc(res_path: string) -> (string)
{
	return resolve_n(res_path, conf.JAR_ROOT)
}

resolve_app_resource :: #force_inline proc(res_path: string) -> (string)
{
	return resolve_n(res_path, conf.APP_ROOT)
}

get_jar_resource :: #force_inline proc(res_path: string) -> (out: j_io.File, err: j_io.Errno)
{
	joined := resolve_jar_resource(res_path)
	//defer delete(joined)

	err = j_io.File_open(&out, joined)
	return
}

get_app_resource :: #force_inline proc(res_path: string) -> (out: j_io.File, err: j_io.Errno)
{
	joined := resolve_app_resource(res_path)
	//defer delete(joined)

	err = j_io.File_open(&out, joined)
	return
}