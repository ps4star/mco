package j_util

Set :: struct($OF: typeid) {
	_items: [dynamic]OF,
}

Set_new :: #force_inline proc($OF: typeid) -> (this: Set(OF))
{
	this._items = make(type_of(this._items))
	return
}

Set_add :: #force_inline proc(this: ^Set($OF), item: OF)
{
	for i in this._items {
		if i == item {
			return
		}
	}
	
	append(this._items, item)
}

Set_clear :: #force_inline proc(this: ^Set($OF))
{
	clear(&this._items)
}