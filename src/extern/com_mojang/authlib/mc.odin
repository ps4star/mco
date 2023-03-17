package cm_authlib

import j_lang "mco:java/lang"
import j_util "mco:java/util"

// @DirectInterfaceImplementation
MinecraftSessionService :: struct
{
	join_server: proc(this: rawptr),
	has_joined_server: proc(this: rawptr),
	get_textures: proc(this: rawptr),
	fill_prof_props: proc(this: rawptr),
	get_secure_prop_value: proc(this: rawptr),
}

GameProfile :: struct
{
	uuid: j_util.UUID,
	name: string,
	// properties: PropertyMap,
	legacy: bool,
}

// IMPL
GameProfile_init :: proc(this: ^GameProfile, uuid: ^j_util.UUID, name: string)
{
	this.uuid = uuid^
	this.name = name
}

// IMPL
GameProfile_new_instance :: #force_inline proc(uuid: ^j_util.UUID, name: string) -> (this: ^GameProfile)
{
	this = new(GameProfile)
	GameProfile_init(this, uuid, name)
	return
}