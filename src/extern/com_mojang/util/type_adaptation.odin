package cm_util
import j_util "mco:java/util"

UUIDTypeAdapter_from_string :: proc(in_s: string) -> (j_util.UUID)
{
	return j_util.UUID_from_string(in_s)
}