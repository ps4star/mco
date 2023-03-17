package cm_bridge

// OBSOLETE (merged into DetectedVersion)

/*import j_util "../../java/util"

GameVersion :: struct {
	get_id: proc(this: ^GameVersion) -> (string),
	get_name: proc(this: ^GameVersion) -> (string),
	get_release_target: proc(this: ^GameVersion) -> (string),
	// default
	get_series_id: proc(this: ^GameVersion) -> (string),
	get_world_version: proc(this: ^GameVersion) -> (int),
	get_protocol_version: proc(this: ^GameVersion) -> (int),
	// default
	// DEPRECATED
	// get_pack_version: proc(this: ^GameVersion) -> (int),
	// default
	get_pack_version_from_pack_type: proc(this: ^GameVersion, pack_type: PackType) -> (int),
	get_build_time: proc(this: ^GameVersion) -> (j_util.Date),
	is_stable: proc(this: ^GameVersion) -> (bool),
}

GameVersion_init :: proc(this: ^GameVersion)
{
	this.get_series_id = proc(this: ^GameVersion) -> (string)
	{
		return "main"
	}

	// DEPRECATED
	/*this.get_pack_version = proc(this: ^GameVersion) -> (int)
	{
		return this->get_pack_version_from_pack_type(.RESOURCE)
	}*/

	this.get_pack_version_from_pack_type = proc(this: ^GameVersion, pack_type: PackType) -> (int)
	{
		return this->get_pack_version()
	}
}*/