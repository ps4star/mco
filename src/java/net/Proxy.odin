package net
import "core:fmt"
import "core:strings"

ProxyType :: enum {
	Direct,
	HTTP,
	Socks,
}

Proxy :: struct {
	type: ProxyType,
	sa: SocketAddress,
}

NO_PROXY := Proxy{ type = .Direct, sa = nil }

Proxy_init_null :: proc(this: ^Proxy)
{
	this.type = NO_PROXY.type
	this.sa = NO_PROXY.sa
}
Proxy_init_type_sa :: proc(this: ^Proxy, type: ProxyType, sa: SocketAddress)
{
	this.type = type
	this.sa = sa
}
Proxy_init :: proc{ Proxy_init_null, Proxy_init_type_sa }

/*
if (obj != null && obj instanceof Proxy) {
    Proxy p = (Proxy)obj;
    if (p.type() == this.type()) {
        if (this.address() == null) {
            return p.address() == null;
        } else {
            return this.address().equals(p.address());
        }
    } else {
        return false;
    }
} else {
    return false;
}
        */
Proxy_equals :: #force_inline proc(this: ^Proxy, other: ^Proxy) -> (bool)
{
	return (other != nil) && (this.sa != nil) && (SocketAddress_equals(this.sa, other.sa))
}