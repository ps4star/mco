package mc
import "core:fmt"
import "core:strings"

import "mco:extern/com_mojang/logging"
import gson "mco:extern/com_google/gson"

import j_io "mco:java/io"
import j_misc "mco:java/misc"
import j_util "mco:java/util"

@(private="file")
glog := &logging.g_logger

MCVersion :: struct {
	id: string,
	name: string,
	stable: bool,
	world_version: DataVersion,
	protocol_version: int,
	resource_pack_version: int,
	data_pack_version: int,
	build_time: j_util.Date,
	release_target: string,
}

MCVersion_BUILT_IN: MCVersion
MCVersion_INIT :: proc()
{
	MCVersion_init(&MCVersion_BUILT_IN)
}

MCVersion_init :: proc(this: ^MCVersion)
{
	id := j_util.UUID_new_from_random()
	this.id = j_util.UUID_to_string_no_hyphens(&id)

	this.name = "1.19" // TODO: should probably be replaced with the thing from shared_constants, right?
	this.stable = true

	this.world_version = DataVersion{ version = 3_105, series = "main" }

	this.protocol_version = get_protocol_version()
	this.resource_pack_version = 9
	this.data_pack_version = 10
	this.build_time = j_util.Date_new_from_current_time()
	return
}

MCVersion_init_json :: proc(this: ^MCVersion, json: ^gson.Object)
{
	this.id = json^["id"].(gson.String)
	this.name = json^["name"].(gson.String)
	this.release_target = json^["release_target"].(gson.String)
	this.stable = json^["stable"].(gson.Boolean)

	this.world_version = {
		/*version = */		cast(int) json^["world_version"].(gson.Integer),
		/*series =*/		gson.get_or_default(json, "series_id", MAIN_SERIES),
	}


}

// @Static
MCVersion_try_detect_version :: proc() -> (^MCVersion)
{
	f: j_io.File
	err := j_io.File_open(&f, j_misc.resolve_jar_resource("version.json"))

	mc_v: ^MCVersion
	for {
		if err != j_io.ERROR_NONE {
			logging.log(.Warn, "Missing version information!")
			mc_v = &MCVersion_BUILT_IN
			break
		}

		json_res := gson.parse_entire_file(f).document.(gson.Object)
		mc_v = new(MCVersion)
		MCVersion_init_json(mc_v, &json_res)
		break
	}

	return mc_v
}