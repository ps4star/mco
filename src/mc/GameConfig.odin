package mc

import blaze "mco_com_mojang:blaze3d"
import prop "mco_com_mojang:authlib/properties"
import j_net "mco:java/net"
import j_io "mco:java/io"

// Since all the classes are essentially just data, we really don't need constructors
FolderData :: struct {
	game_dir: j_io.File,
	res_pack_dir: j_io.File,
	asset_dir: j_io.File,
	asset_index: string,
}

/*// Init necessary here to convert the string to a real AssetIndex
FolderData_init :: proc(this: ^FolderData, game_dir: j_io.File, res_pack_dir: j_io.File, asset_dir: j_io.File, asset_index: string)
{
	this.game_dir = game_dir
	this.res_pack_dir = res_pack_dir
	this.asset_dir = asset_dir
	this.asset_index = asset_index
}*/
FolderData_get_asset_index :: proc(this: ^FolderData) -> (out: AssetIndex)
{
	if len(this.asset_index) == 0 {
		dai: DirectAssetIndex
		DirectAssetIndex_init(&dai, this.asset_dir)
		out = dai.asset_index
	} else {
		AssetIndex_init(&out, this.asset_dir, this.asset_index)
	}

	return
}

GameData :: struct {
	demo: bool,
	launch_version: string,
	version_type: string,
	disable_multi: bool,
	disable_chat: bool,
}

ServerData :: struct {
	hostname: string,
	port: int,
}

UserData :: struct {
	user: User,
	user_props: prop.PropertyMap,
	profile_props: prop.PropertyMap,
	proxy: j_net.Proxy,
}

GameConfig :: struct {
	user: UserData,
	display: blaze.DisplayData,
	location: FolderData,
	game: GameData,
	server: ServerData,
}

/*GameConfig_new :: proc(user: UserData, display: cm_plat.DisplayData, location: FolderData, game: GameData, server: ServerData) -> (out: GameConfig)
{
	out.user = user
	out.display = display
	out.location = location
	out.game = game
	out.server = server
	return
}

GameConfig_UserData_new :: proc(user: User, up, pp: prop.PropertyMap, proxy: net.Proxy) -> (out: UserData)
{
	out.user = user
	out.user_properties = up
	out.profile_properties = pp
	out.proxy = proxy
	return
}

GameConfig_FolderData_new :: proc(game_dir, res_pack_dir, asset_dir, asset_index: string) -> (out: FolderData)
{
	out.game_dir = game_dir
	out.res_pack_dir = res_pack_dir
	out.asset_dir = asset_dir
	out.asset_index = asset_index
	return
}*/