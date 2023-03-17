package mc

import cm_df "mco:extern/com_mojang/datafixerupper"
import cm_auth "mco:extern/com_mojang/authlib"

// @RecordType
// @NoInit
Services :: struct
{
	session_service: cm_auth.MinecraftSessionService,
	serv_sig_validator: SignatureValidator,
	prof_repo: GameProfileRepository,
	prof_cache: GameProfileCache,
}

// @RecordType
// @NoInit
WorldStem :: struct
{
	res_mgr: CloseableResourceManager,
	data_pack_resources: ReloadableServerResources,
	registry_access: RegistryAccess,
	wdata: WorldData,
}

WorldStem_close :: proc(this: ^WorldStem)
{
	assert(this.res_mgr.close != nil)
	this.res_mgr.close((rawptr)(&(this.res_mgr)))
}