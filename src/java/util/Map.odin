package j_util

// Map works differently here and actually provides implementation of common stuff
// Sub-types actually just nest a Map inside of them and then do extra stuff after.
Map :: struct($K, $V: typeid) {
	_keys: [dynamic]K,
	_vals: [dynamic]V,
}

Map_new :: proc($K, $V: typeid, alloc := context.allocator) -> (out: Map(K, V))
{
	out._keys = make(type_of(out._keys), alloc)
	out._vals = make(type_of(out._vals), alloc)
	return
}

Map_entry_set :: proc(this: ^Map($K, $V)) -> ([dynamic]V)
{
	return this._vals
}

Map_get :: proc(this: ^Map($K, $V), name: K) -> (V, bool)
{
	for key, i in this._keys {
		if key == name {
			return this._vals[i], true
		}
	}
	return _, false
}