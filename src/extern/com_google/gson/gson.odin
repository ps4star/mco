package google_gson

import j_io				"mco:java/io"

// Emulates com_google.gson via Odin's encoding/json pkg
import ojson "core:encoding/json"
import "core:os"

Value :: ojson.Value
Error :: ojson.Error

Object :: ojson.Object
Array :: ojson.Array
String :: ojson.String
Boolean :: ojson.Boolean
Integer :: ojson.Integer

Null :: ojson.Null

Gson :: struct
{
	document: Value,
}

/*
Takes in a j_io.File and inits an odin JSON parser.
Returns a malloced ptr to Gson.
nil if error occurred.
*/
// @LingeringAlloc
parse_entire_file :: proc(in_f: j_io.File) -> (^Gson)
{
	out := new(Gson)
	dt, f_succ := os.read_entire_file_from_handle(in_f.odin_handle) // @HeavyOperation

	if !f_succ { delete(dt); return nil }

	err: Error; out.document, err = ojson.parse(dt) // @HeavyOperation
	if err != .None { delete(dt); return nil }

	delete(dt)
	return out
}

/*
Returns true if root is Object
*/
is_object_root :: #force_inline proc(this: ^Gson) -> (bool)
{
	_, ok := this.document.(Object)
	return ok
}

get_or_default :: proc(json_obj: ^Object, k: string, default: $T) -> (T)
	where T == String ||
	T == Integer ||
	T == Boolean
{
	item, worked := json_obj^[k]
	if !worked {
		return default
	}
	return item.(T)
}

/*
Iterates over all items at the root level.
This is NOT recursive.
The user should implement recursion themselves.
*/
/*iterate :: proc(this: ^Gson)
{
	#partial switch v in this.document {
	case Object:

	}
}*/

/*
Destroys a ^Gson
*/
destroy :: proc(this: ^Gson)
{
	ojson.destroy_value(this.document)
	free(this)
}