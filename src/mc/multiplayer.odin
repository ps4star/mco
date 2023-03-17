package mc

import cm_auth "mco:extern/com_mojang/authlib"

ProfilePublicKey :: struct
{

}



ProfileKeyPairManager :: struct
{
	public_key: Maybe(ProfilePublicKey),
	signer: Signer,
}

ProfileKeyPairManager_profile_public_key :: proc(this: ^ProfileKeyPairManager) -> (Maybe(ProfilePublicKey))
{
	return this.public_key
}



MultiPlayerGameMode :: struct
{
	minecraft: ^Minecraft,

	// destroying_item: 
	local_player_mode: GameType,
}

MultiPlayerGameMode_get_pick_range :: proc(this: ^MultiPlayerGameMode) -> (f32)
{
	return 5.0 if GameType_is_creative(&this.local_player_mode) else 4.5
}




ClientPacketListener :: struct
{

}

ClientPacketListener_get_local_game_profile :: proc(this: ^ClientPacketListener) -> (^cm_auth.GameProfile)
{
	return nil
}