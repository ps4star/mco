package mc

BlockBehavior :: struct
{

}

BlockState :: struct
{

}

Block :: struct
{
	
}

Blocks :: enum
{
	Air,
}

BlocksValue :: Block
BlocksValues := [Blocks]^BlocksValue{}

Blocks_get :: #force_inline proc(key: Blocks) -> (^BlocksValue)
{
	return BlocksValues[key]
}