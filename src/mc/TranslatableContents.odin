package mc

TCArgsType :: []rawptr
@private NO_ARGS := TCArgsType(nil)
TranslatableContents :: struct
{
	key: string,
	args: TCArgsType,
}

TranslatableContents_init_no_args :: proc(this: ^TranslatableContents, key: string)
{
	this.key = key
	this.args = NO_ARGS
}

TranslatableContents_init_args :: proc(this: ^TranslatableContents, key: string, args: TCArgsType)
{
	this.key = key
	this.args = args
}

TranslatableContents_init :: proc{
	TranslatableContents_init_no_args,
	TranslatableContents_init_args,
}

@private TranslatableContents_decompose :: proc(this: ^TranslatableContents)
{
	lang := Language_INST
}