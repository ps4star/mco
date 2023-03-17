package net

SocketAddressType :: enum {
	UNSPECIFIED,
	INET,
}

SocketAddressCommon :: struct {
	type: SocketAddressType,
}

SocketAddress_serial_version_UID :: 5215720748342549866
SocketAddress :: union {
	InetSocketAddress,
}

SocketAddress_equals :: proc(a: SocketAddress, b: SocketAddress) -> (bool)
{
	switch type in a {
		case InetSocketAddress:
			return InetSocketAddress_equals(type, b)
		case:
			assert(false)
			return false
	}
}