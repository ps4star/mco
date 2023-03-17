package mc
import j_func "mco:java/util/function"

HeightMap_Usage :: enum
{
	Worldgen,
	LiveWorld,
	Client,
}

HeightMap_Types :: enum
{
	WSurfaceWG,
	WSurface,
	OceanFloorWG,
	OceanFloor,
	MotionBlocking,
	MotionBlockingNoLeaves,
}

HeightMap_TypesValue :: struct
{
	ser_key: string,
	usage: HeightMap_Usage,
	is_opaque: j_func.Predicate(^BlockState),
}

HeightMap_TypesValues :: [HeightMap_Types]HeightMap_TypesValue{

}