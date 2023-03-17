package mc

// @Implements mc/util#OptionEnum
CloudStatus :: enum
{
	Off,
	Fast,
	Fancy,
}

CloudStatusValue :: struct
{
	id: int,
	key: string,
}

CloudStatusValues := [CloudStatus]CloudStatusValue{
	.Off = { 0, "options.off" },
	.Fast = { 1, "options.clouds.fast" },
	.Fancy = { 2, "options.clouds.fancy" },
}

CloudStatus_get_caption :: proc(c: CloudStatus) -> (^Component)
{
	return Component_translatable(CloudStatusValues[c].key)
}