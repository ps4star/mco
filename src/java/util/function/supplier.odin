package j_util_function
import global "mco:odin/global"

Supplier :: struct($T: typeid)
{
	get: proc(ctx: rawptr) -> (T),
}

Supplier_get :: #force_inline proc(this: ^Supplier($T), ctx: rawptr) -> (T)
{
	return this.get(ctx)
}

IntSupplier :: Supplier(int)
LongSupplier :: Supplier(i64)