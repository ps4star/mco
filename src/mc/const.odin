package mc

import global "mco:odin/global"
import conf "mco:odin/conf"

SNAPSHOT :: false 							// @Deprecated
WORLD_VERSION :: 3_105						// @Deprecated
SERIES :: "main"							// @Deprecated
VERSION_STRING :: "1.19"					// @Deprecated
RELEASE_TARGET :: "1.19"					// @Deprecated
RELEASE_NETWORK_PROTOCOL_VERSION :: 759 	// @Deprecated
SNAPSHOT_NETWORK_PROTOCOL_VERSION :: 91		// @Deprecated
SNBT_NAG_VERSION :: 3_075
SNAPSHOT_PROTOCOL_BIT :: 30
THROW_ON_TASK_FAILURE :: false
RESOURCE_PACK_FORMAT :: 9					// @Deprecated
DATA_PACK_FORMAT :: 10						// @Deprecated
DATA_VERSION_TAG :: "DataVersion"
CNC_PART_2_ITEMS_AND_BLOCKS :: false
USE_NEW_RENDERSYSTEM :: false
MULTITHREADED_RENDERING :: false
FIX_TNT_DUPE :: false
FIX_SAND_DUPE :: false

USE_DEBUG_FEATURES :: false
DEBUG_OPEN_INCOMPATIBLE_WORLDS :: false
DEBUG_ALLOW_LOW_SIM_DISTANCE :: false
DEBUG_HOTKEYS :: false

@private CURRENT_VERSION: ^MCVersion

// TODO: rest of shared constants

// @Static
try_detect_version :: proc()
{
	if CURRENT_VERSION == nil {
		CURRENT_VERSION = MCVersion_try_detect_version()
	}
}

// @Static
get_protocol_version :: #force_inline proc() -> (int)
{
	return 759
}

// @Static
get_current_version :: #force_inline proc() -> (^MCVersion)
{
	if CURRENT_VERSION == nil {
		global.throw_unchecked({ .IllegalStateException }, "Game version not set")
		return nil
	} else {
		return CURRENT_VERSION
	}
}