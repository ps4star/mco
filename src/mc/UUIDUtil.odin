package mc
import j_util "mco:java/util"

// Some UUID utility procs

UUIDUtil_create_offline_player_uuid :: proc(str: string) -> (j_util.UUID)
{
	// TODO: return j_util.UUID_name_from_bytes( transmute([]u8) strings.concatenate({ "OfflinePlayer:", str })
	return j_util.UUID_new_from_random()
}