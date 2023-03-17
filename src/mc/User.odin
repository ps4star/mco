package mc
import "core:strings"

import global "mco:odin/global"

import j_util "mco:java/util"

import cm_auth "mco:extern/com_mojang/authlib"
import cm_util "mco:extern/com_mojang/util"

UserType :: enum
{
	Legacy,
	Mojang,
	Msa,
}

User :: struct
{
	name: string,
	uuid: string,
	access_token: string,
	xuid: string,
	client_id: string,
	type: UserType,
}

User_new :: proc(name, uuid, access_token, xuid, client_id: string, type: UserType) -> (out: User)
{
	out.name = name
	out.uuid = uuid
	out.access_token = access_token
	out.xuid = xuid
	out.client_id = client_id
	out.type = type
	return
}

User_get_session_id :: proc(user: ^User) -> (string)
{
	return strings.concatenate({ "token:", user.access_token, ":", user.uuid })
}

User_get_game_profile :: proc(this: ^User) -> (^cm_auth.GameProfile)
{
	uuid: j_util.UUID
	{
		global.push_exception_frame()

		uuid = cm_util.UUIDTypeAdapter_from_string(this.uuid)
		if global.catch({ .IllegalArgumentException }) {
			return cm_auth.GameProfile_new_instance((^j_util.UUID)(nil), this.name)
		}

		global.check(); global.pop_exception_frame()
		return cm_auth.GameProfile_new_instance(&uuid, this.name)
	}
}