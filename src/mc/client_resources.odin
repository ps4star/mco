package mc
import "core:strings"

import j_io				"mco:java/io"

import global "mco:odin/global"

AssetIndex :: struct
{
	root_files: map[string]j_io.File,
	namespaced_files: map[^ResourceLocation]j_io.File,
}

AssetIndex_init :: proc(a: ^AssetIndex, f: j_io.File, s: string)
{
	cat_path := strings.concatenate({ "indexes/", s, ".json" })
	defer delete(cat_path)

	file1: j_io.File; j_io.File_open(&file1, "objects")
	file2: j_io.File; j_io.File_open(&file2, cat_path)

	{
		global.push_exception_frame()
		defer { global.check(); global.pop_exception_frame() }

		// Grab "objects" sub-obj from the JSON
	}
}

DirectAssetIndex :: struct
{
	using asset_index: AssetIndex,
	assets_dir: j_io.File,
}

DirectAssetIndex_init :: proc(this: ^DirectAssetIndex, file: j_io.File)
{
	this.assets_dir = file
}

@private BUILT_IN := PackMetadataSection{}
ClientPackSource :: struct
{
	vanilla_pack: VanillaPackResources,
	server_pack_dir: j_io.File,
	// download_lock: ReentrantLock,
	asset_index: AssetIndex,
	server_pack: Pack,
}

ClientPackSource_init :: proc(this: ^ClientPackSource, f: j_io.File, asset_index: AssetIndex)
{
	this.server_pack_dir = f
	this.asset_index = asset_index
	DefaultClientPackResources_init(transmute(^DefaultClientPackResources) &this.vanilla_pack, BUILT_IN, asset_index)
}

DefaultClientPackResources :: struct
{
	using vanilla: VanillaPackResources,
	asset_index: AssetIndex,
}

DefaultClientPackResources_init :: proc(this: ^DefaultClientPackResources, pack_meta: PackMetadataSection, asset_index: AssetIndex)
{
	VanillaPackResources_init(transmute(^VanillaPackResources) this, pack_meta, "minecraft", "realms")
	this.asset_index = asset_index
}