package j_util

ArrayList :: struct($V: typeid) {
	_internal: [dynamic]V,
}

ArrayList_impl :: proc(this: ^ArrayList($K, $V))
{
	
}

ArrayList_new :: proc($V: typeid) -> (out: ArrayList(V))
{
	ArrayList_impl(&out)
	return
}