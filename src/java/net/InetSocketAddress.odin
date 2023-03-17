package net

/*
private final transient InetSocketAddressHolder holder;
private static final long serialVersionUID = 5076001401234631237L;
private static final ObjectStreamField[] serialPersistentFields;
private static final Unsafe UNSAFE;
private static final long FIELDS_OFFSET;
*/

InetSocketAddress_serial_version_UID :: 5076001401234631237
InetSocketAddress_serial_persistent_fields := [dynamic]string{}
//InetSocketAddress_UNSAFE :: nil
InetSocketAddress_fields_offset := u64(0)
InetSocketAddress :: struct {
	hostname: string,
	addr: InetAddress,
	port: int,
}

InetSocketAddress_init :: proc(addr: ^InetSocketAddress, hostname: string, port: int)
{
	// check_host(hostname)
	addr: Maybe(InetAddress) = nil
	host: Maybe(string) = nil
	// return InetSocketAddress{}
}

InetSocketAddress_equals :: proc(s1: InetSocketAddress, s2: SocketAddress) -> (bool)
{
	switch type in s2 {
		case InetSocketAddress:
			return InetAddress_equals(s1.addr, type.addr)
		case:
			assert(false)
			return false
	}
}