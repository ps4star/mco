package odin_global
import "core:fmt"

import "mco:odin/conf"

dbprint :: #force_inline proc(args: ..any)
{
	when conf.DEBUG == conf.YES {
		fmt.println(args)
	}
}