package mc
import "core:fmt"
import "core:strings"

import "mco:odin/global"

import j_lang "mco:java/lang"
import j_net "mco:java/net"

import "mco:extern/com_mojang/logging"
import cm_df "mco:extern/com_mojang/datafixerupper"
import cm_auth "mco:extern/com_mojang/authlib"

/*@(private="file")
glog := &logging.g_logger*/

MinecraftServer_VANILLA_BRAND :: "vanilla"
// ... (static vars)

MinecraftServer :: struct
{
	is_saving: bool, // @Volatile
	single_player_profile: cm_auth.GameProfile,

	server_thread: ^j_lang.Thread,
}

MinecraftServer_init :: proc(this: ^MinecraftServer,
	thread: ^j_lang.Thread,
	lv_sa: ^LevelStorageAccess,
	pr: ^PackRepository,
	ws: ^WorldStem,
	p: ^j_net.Proxy,
	df: ^cm_df.DataFixer,
	ser: ^Services,
	cplf: ChunkProgressListenerFactoryProc)
{


	this.server_thread = thread
}

MinecraftServer_set_single_player_profile :: proc(this: ^MinecraftServer, game_prof: ^cm_auth.GameProfile)
{
	this.single_player_profile = game_prof^
}

MinecraftServer_set_demo :: proc(this: ^MinecraftServer, is: bool)
{
	
}

/*MinecraftServer_init :: proc(this: ^MinecraftServer,
	t: ^j_lang.Thread,
	lsa: LevelStorageAccess,
	pack_repo: PackRepo,
	ws: WorldStem,
	p: net.Proxy,
	df: DataFixer,
	ser: Services,
	cplf: ChunkProgressListenerFactory) -> (this: MinecraftServer)
{
	
}*/

IntegratedServer :: struct
{
	using minecraft_server: MinecraftServer,
}

IntegratedServer_new :: proc() -> (out: IntegratedServer)
{
	return
}

IntegratedServer_halt :: proc(this: ^IntegratedServer, modifier: bool)
{
	
}