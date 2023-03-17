package properties

Property :: struct {
	name, value, signature: string,
}

Property_new_no_sig :: proc(name, value: string) -> (Property)
{
	return Property_new_sig(name, value, "")
}
Property_new_sig :: proc(name, value, signature: string) -> (out: Property)
{
	out.name = name
	out.value = value
	out.signature = signature
	return
}
Property_new :: proc{ Property_new_sig, Property_new_no_sig }

Property_has_signature :: #force_inline proc(this: ^Property) -> (bool)
{
	return len(this.signature) > 0
}