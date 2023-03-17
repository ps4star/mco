package mc

// @NeverPointer
ChunkPos :: [2]i32

/*ChunkPos_from_block :: proc(bp: BlockPos)
{

}*/

ChunkType :: enum
{
	ProtoChunk,
	LevelChunk,
}

ChunkHolder :: struct
{

}

ChunkAccess :: struct
{

}

ChunkLoadingFailure :: struct {}
ChunkAccessOrFailure :: union
{
	ChunkAccess,
	ChunkLoadingFailure,
}

GenerationTask :: #type proc() -> (^ChunkAccessOrFailure)
LoadingTask :: #type proc() -> (^ChunkAccessOrFailure)
ChunkStatus :: struct
{
	name: string, // @Final
	index: int, // @Final
	parent: ^ChunkStatus, // @Final
	gtask: GenerationTask, // @Final
	ltask: LoadingTask, // @Final
	range: int, // @Final
	chunk_type: ChunkType, // @Final
	hmaps_after: ^[HeightMap_Types]HeightMap_TypesValue,
}

