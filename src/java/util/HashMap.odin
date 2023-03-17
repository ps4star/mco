package j_util
import "core:slice"

HashMap :: struct($K, $V: typeid) {
	_internal: map[K]V,
}

HashMap_new :: proc($K, $V: typeid) -> (out: HashMap(K, V))
{
	out._internal = make(type_of(out._internal))
	return
}

HashMap_contains_key :: proc(this: ^HashMap($K, $V), key: K) -> (bool)
{
	return (key in this._internal)
}

HashMap_entry_set :: proc(this: ^HashMap($K, $V)) -> ([]K)
{
	return 
}

HashMap_get :: proc(this: ^HashMap($K, $V), key: K) -> (V)
{
	return this._internal[key]
}