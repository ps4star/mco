package mc
import "core:fmt"
import odin_os "core:os"

import j_misc			"mco:java/misc"
import j_io				"mco:java/io"

import gson "mco:extern/com_google/gson"

import global "mco:odin/global"
import conf "mco:odin/conf"

LocaleString :: string

DEFAULT_LOCALE := LocaleString("en_us")
Language_INST: ^Language = nil

/*
Usually we do not do interface abstracts (or class abstracts) as
literal proc ptrs, but here, since
there are only 2 inheritors of Language and only 4 abstracts, it
is manageable and more useful to do it like this.
*/
Language :: struct
{
	m: map[string]string,

	get_or_default: proc(this: rawptr, str: string) -> (string),
	has: proc(this: rawptr, str: string) -> (bool),
	is_default_right_to_left: proc(this: rawptr) -> (bool),
	get_visual_order: proc(this: rawptr, f: FmtText) -> (FmtCharSeq),
}

// @Static
Language_load_from_json :: proc(in_f: j_io.File, m: ^map[string]string, bc: proc(^map[string]string, string, string))
{
	json := gson.parse_entire_file(in_f) // ^gson.Gson
	defer gson.destroy(json)
	assert(gson.is_object_root(json), fmt.aprintf("language.odin#Language_load_from_json: Root element is not object for file %s", in_f.path))

	// Should only contain string -> gson.String mappings
	root_as_obj := json.document.(gson.Object) // map[string]Value
	for k, v in &root_as_obj {
		// Debug

		// Unsafe cast if we can assume it's valid
		when conf.ASSUME_VALID_JAR_LANGUAGE_JSONS == conf.YES {
		vstr := (^gson.String)(&v)^
		} else {
		vstr := v.(gson.String)
		}
		
		// We've grabbed the raw str value, so let's put it into the biconsumer proc
		bc(m, k, vstr)
	}
}

// @Static
@private working_map: map[string]string // scoped vars not passable to child procs so we need to make it a global
@private load_default :: proc() -> (^Language)
{
	out := new(Language)
	m := map[string]string{}

	{
		global.push_exception_frame()
		defer { global.check(); global.pop_exception_frame() }

		in_file, err := j_misc.get_jar_resource("/assets/minecraft/lang/en_us.json") // getResourceAsStream()
		assert(err == odin_os.ERROR_NONE)

		{
			global.push_exception_frame()
			defer { global.check(); global.pop_exception_frame() }

			Language_load_from_json(in_file, &m, proc(m: ^map[string]string, s1, s2: string)
			{
				(m^)[s1] = s2 // write entries into copy map
			})

			// Now return the lang
			out^ = {
				m = m,
				get_or_default = proc(this: rawptr, str: string) -> (string)
				{
					this := (^Language)(this)
					retval, worked := this.m[str]
					if !worked { return "" }
					return retval
				},

				has = proc(this: rawptr, str: string) -> (bool)
				{
					this := (^Language)(this)
					return (str in this.m)
				},

				is_default_right_to_left = proc(this: rawptr) -> (bool)
				{
					// this := (^Language)(this)
					return false
				},

				get_visual_order = proc(this: rawptr, f: FmtText) -> (FmtCharSeq)
				{
					this := (^Language)(this)
					return nil
					// TODO(ps4star): impl proper return proc
				},
			}
			return out
		}
	}

	free(out)
	return nil
}

Language_INIT :: proc()
{
	Language_INST = load_default()
}