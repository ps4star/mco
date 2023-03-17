package j_util

IdentityHashMap :: struct($V, $K: typeid) {
	
}

IdentityHashMap_new :: proc($V, $K: typeid) -> (IdentityHashMap(V, K))
{
	return IdentityHashMap(V, K){}
}