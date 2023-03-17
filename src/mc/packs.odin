package mc

import mc_bridge "mco:extern/com_mojang/bridge"

PackType :: enum
{
	ClientRes,
	ServerData,
}

PackTypeValue :: struct
{
	dir: string,
	bridge_type: mc_bridge.PackType,
}

Pack :: struct
{
	id: string,
}