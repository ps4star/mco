package mc_common

import j_lang			"mco_java:lang"
import j_func			"mco_java:util/function"

Util_time_source := j_func.LongSupplier{ get = proc(ctx: rawptr) -> (i64)
{
	return j_lang.System_nano_time()
}}

Util_get_millis := j_func.LongSupplier{ get = proc(ctx: rawptr) -> (i64)
{
	return Util_time_source.get(ctx) / 1_000_000
}}
