package mc

import guava_collect "mco:extern/com_google/guava/common/collect"

import j_util			"mco:java/util"
import j_io				"mco:java/io"

// Literally just a data holder obj
PackMetadataSection :: struct
{
	desc: Component,
	pack_fmt: int,
}



PackResources :: struct
{
	type: typeid,

	get_root_resource: proc(rawptr, string) -> (j_io.File),
	get_resource: proc(rawptr, PackType, ResourceLocation) -> (j_io.File),
	get_resources: proc(rawptr, PackType, string, string, proc(rawptr, ^ResourceLocation) -> (bool)) -> ([]ResourceLocation),
	has_resource: proc(rawptr, PackType, ResourceLocation) -> (bool),
	get_namespaces: proc(rawptr, PackType) -> ([]string),

	get_metadata_section: proc(rawptr),
	get_name: proc(rawptr) -> (string),
	close: proc(rawptr),
}

VanillaPackResources :: struct
{
	using abstract: PackResources,
	pack_meta: PackMetadataSection,
	namespaces: []string, // (Immutable)Set<String>
}

VanillaPackResources_init :: proc(this: ^VanillaPackResources, pack_meta: PackMetadataSection, nses: ..string)
{
	this.pack_meta = pack_meta
	#assert(type_of(nses[:]) == []string)
	this.namespaces = guava_collect.create_immutable_set_from_slice(nses[:])
}