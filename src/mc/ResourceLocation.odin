package mc
import "core:fmt"
import "core:strings"

import j_misc "mco:java/misc"

import "mco:odin/global"

ResourceLocation_NAMESPACE_SEPARATOR :: ':'
ResourceLocation_DEFAULT_NAMESPACE :: "minecraft"
ResourceLocation_REALMS_NAMESPACE :: "realms"
ResourceLocation_constructor_err := false

ResourceLocation :: struct
{
	namespace: string,
	path: string,

	// _err: bool,
}

ResourceLocation_new_str_slice :: proc(args: []string) -> (this: ResourceLocation)
{
	// assert(len(args) > 0, fmt.aprintf("0-length []string passed to ResourceLocation constructor."))
	// fmt.println(args)
	this.namespace = "minecraft" if len(args[0]) < 1 else args[0]
	this.path = args[1]

	// TODO: impl validity check
	// this._err = (!is_valid_namespace(this.namespace)) || (!is_valid_path(this.path))
	assert(is_valid_namespace(this.namespace) && is_valid_path(this.path),
		fmt.tprintln("NS:", this.namespace, "\nPATH:", this.path))
	return
}
ResourceLocation_new_str :: proc(str: string) -> (ResourceLocation)
{
	// assert(len(str) > 0, fmt.aprintf("0-length string passed to ResourceLocation constructor."))
	return ResourceLocation_new_str_slice(ResourceLocation_decompose(str, ResourceLocation_NAMESPACE_SEPARATOR))
}
ResourceLocation_new_2_str :: proc(str1, str2: string) -> (ResourceLocation)
{
	return ResourceLocation_new_str_slice([]string{ str1, str2 })
}
ResourceLocation_new :: proc{ ResourceLocation_new_str_slice, ResourceLocation_new_str, ResourceLocation_new_2_str }

ResourceLocation_try_build :: ResourceLocation_new_2_str

ResourceLocation_decompose :: proc(str: string, ch: u8) -> ([]string)
{
	astring := make([]string, 2)
	astring[0] = "minecraft"
	astring[1] = str
	
	i := strings.index_byte(str, ch)
	if i >= 0 {
		astring[1] = str[i+1:len(str)]
		if i >= 1 {
			astring[0] = str[0:i]
		}
	}

	// fmt.println(astring)
	return astring
}

@(private="file")
is_valid_path :: proc(str: string) -> (bool)
{
	for i := 0; i < len(str); i += 1 {
		if !ResourceLocation_valid_path_char(str[i]) {
			return false
		}
	}

	return true
}

@(private="file")
is_valid_namespace :: proc(str: string) -> (bool)
{
	for i := 0; i < len(str); i += 1 {
		if !ResourceLocation_valid_namespace_char(str[i]) {
			return false
		}
	}

	return true
}

// @LingeringAlloc
ResourceLocation_to_string :: proc(this: ^ResourceLocation) -> (string)
{
	return strings.concatenate({ this.namespace, ":", this.path })
}


ResourceLocation_valid_path_char :: #force_inline proc(ch: u8) -> (bool)
{
	return ch == '_' || ch == '-' || ch >= 'a' && ch <= 'z' || ch >= '0' && ch <= '9' || ch == '/' || ch == '.'
}

ResourceLocation_valid_namespace_char :: #force_inline proc(ch: u8) -> (bool)
{
	return ch == '_' || ch == '-' || ch >= 'a' && ch <= 'z' || ch >= '0' && ch <= '9' || ch == '.'
}

// @Static
ResourceLocation_is_valid_resource_location :: proc(s: string) -> (bool)
{
	astring := ResourceLocation_decompose(s, ':')
	return is_valid_namespace("minecraft" if len(astring[0]) < 1 else astring[0]) && is_valid_path(astring[1])
}

// CUSTOM
// Creates an RL with global.resolve(path) as the string
/*ResourceLocation_resolve_app :: proc(path: string) -> (ResourceLocation)
{
	return ResourceLocation_new(j_misc.resolve_app_resource(path))
}

ResourceLocation_resolve_jar :: proc(path: string) -> (ResourceLocation)
{
	return ResourceLocation_new(j_misc.resolve_jar_resource(path))
}

ResourceLocation_resolve :: ResourceLocation_resolve_jar*/