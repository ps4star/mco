package jopt_simple
import "core:strings"
import "core:os"
import "core:slice"
import "core:strconv"

// Seriously simplified version of the original
// As you may expect, jopt_simple has a ton of Java OOP bloat
// The pkg is heavily simplified here.

ALLOWED_ARG_DELIMS :: [?]u8{ ':', '=' }
ArgType :: enum {
	Unspecified,
	Optional,
	Required,
}

OptionSpec :: struct {
	arg_type: ArgType,
	arg_value_type: ArgType,
	default_value: string,
}

OptionParser :: struct {
	allows_unrecognized_options: bool,
	in_args: map[string]OptionSpec,

	_found_args: [dynamic]string,
	_unhandled_args: [dynamic]string,
	_prim_args_to_values: map[string]string,
}

// Establishes a string arg which can be accepted by the parser
OptionParser_accepts :: proc(this: ^OptionParser, arg: string, arg_type, arg_value_type: ArgType, default_value: string)
{
	this.in_args[arg] = OptionSpec{
		arg_type,
		arg_value_type,
		default_value,
	}
}

// Parses
OptionParser_parse :: proc(this: ^OptionParser, args: []string)
{
	for arg in args
	{
		parts := strings.split(arg, "=")
		if (arg in this.in_args)
		{
			append(&this._found_args, parts[0])
			this._prim_args_to_values[parts[0]] = parts[1]
		} else
		{
			append(&this._unhandled_args, parts[0])
		}
	}

	for arg, spec in &(this.in_args)
	{
		// Arg has not been found in the data yet so let's set to default value
		if !(slice.contains(this._found_args[:], arg)) && !(slice.contains(this._unhandled_args[:], arg))
		{
			this._prim_args_to_values[arg] = this.in_args[arg].default_value
		}
	}
}

// Whether a value exists
OptionParser_has :: proc(this: ^OptionParser, name: string) -> (bool)
{
	return (name in this._prim_args_to_values)
}

// Gets a value
OptionParser_get :: proc(this: ^OptionParser, name: string, $T: typeid) -> (T)
{
	when T == string {
		return this._prim_args_to_values[name]
	} else when T == int {
		return strconv.atoi(this._prim_args_to_values[name])
	}
}

// Returns a []String of all the things that were not recognized as options during parsing
OptionParser_non_options :: proc(this: ^OptionParser) -> ([]string)
{
	return this._unhandled_args[:]
}