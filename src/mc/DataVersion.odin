package mc

MAIN_SERIES :: "main"
DataVersion :: struct {
	version: int,
	series: string,
}

// There's not really any sense in having this; just make immediate DataVersion structs
/*DataVersion_init :: #force_inline proc(dv: ^DataVersion, version: int, series: string)
{
	dv.version = version
	dv.series = series
}*/

DataVersion_is_side_series :: proc(dv: ^DataVersion) -> (bool)
{
	return !(dv.series == MAIN_SERIES)
}

DataVersion_is_compatible :: proc(dv: ^DataVersion, other: ^DataVersion) -> (bool)
{
	return dv.series == other.series
}