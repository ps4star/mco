package mc

/*SignatureValidator :: struct
{

}*/

SignatureValidator :: #type proc(b1, b2: []byte) -> (bool)

/*SignatureValidator :: struct
{
	validate_with_updater: proc(this: rawptr, su: SignatureUpdater, byte_arr: []byte) -> (bool),
	validate_with_bytes: proc(this: rawptr, b1, b2: []byte) -> (bool),
}

SignatureValidator_init :: proc(this: ^SignatureValidator)
{
	this.validate_with_bytes = proc(this: rawptr, b1, b2: []byte) -> (bool)
	{
		return (^SignatureValidator)(this).validate_with_updater(this, proc(out: SUOutput))
	}
}

sig_validate :: proc(this: rawptr, ) -> (bool)
{

}*/