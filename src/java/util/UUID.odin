package j_util
import "core:fmt"
import "core:strings"
import "core:strconv"

import conf "mco:odin/conf"
import rng "mco:odin/rng"

import "mco:odin/global"

// Replacement for java.util.UUID

// Since Odin has u128 and UUID is supposed to represent a 128-bit number,
// we include a compile flag (USE_NATIVE_UUID) that just makes UUID == u128
// If set to YES, uses Odin's native u128 type, otherwise uses a struct with 2 u64 values.

// This should be set to YES if the host machine supports hardware 128-bit integers or otherwise efficiently handle them
// If it cannot, this should be NO.
// Default is NO

when conf.USE_NATIVE_UUID == conf.NO {
	UUID :: struct {
		most_sig: u64,
		least_sig: u64,
	}

	UUID_nil := UUID{} // internal use only
} else when conf.USE_NATIVE_UUID == conf.YES {
	UUID :: u128

	UUID_nil := UUID(0) // internal use only
} else {
	#panic(conf.PANIC_MSG + "USE_NATIVE_UUID != YES|NO")
}

UUID_init_from_u64s :: #force_inline proc(uuid: ^UUID, most_sig: u64, least_sig: u64)
{
	when conf.USE_NATIVE_UUID == conf.YES {
		uuid^ = (UUID(most_sig) << 64) | UUID(least_sig)
	} else {
		uuid.most_sig = most_sig
		uuid.least_sig = least_sig
	}
}

@(private="file")
UUID_new_from_bytes :: proc(bytes: [16]byte) -> (UUID)
{
	out: UUID
	when conf.USE_NATIVE_UUID == conf.YES {
		for i := 0; i < 16; i += 1 {
			out = (out << 8) | (bytes[i] & 0xff)
		}
	} else {
		for i := 0; i < 8; i += 1 {
			out.most_sig = (out.most_sig << 8) | u64(bytes[i] & 0xff)
		}

		for i := 0; i < 8; i += 1 {
			out.least_sig = (out.least_sig << 8) | u64(bytes[i] & 0xff)
		}
	}
	return out
}

UUID_new_from_random :: proc() -> (UUID)
{
	rand_bytes := rng.random_bytes(16)
	rand_bytes[6] &= 0x0f
	rand_bytes[6] |= 0x40
	rand_bytes[8] &= 0x3f
	rand_bytes[8] |= 0x80
	return UUID_new_from_bytes(rand_bytes)
}

// TODO: impl correctly
UUID_to_string :: #force_inline proc(uuid: ^UUID) -> (string)
{
	when conf.USE_NATIVE_UUID == conf.NO {
		s1 := strconv.itoa(global.g_itoa_buf[:63], cast(int) uuid^.most_sig)
		s2 := strconv.itoa(global.g_itoa_buf[64:], cast(int) uuid^.least_sig)
		return strings.concatenate({ s1, s2 })
	} else {
		return ""
	}
}

// TODO: impl correctly
UUID_to_string_no_hyphens :: #force_inline proc(uuid: ^UUID) -> (string)
{
	when conf.USE_NATIVE_UUID == conf.NO {
		s1 := strconv.itoa(global.g_itoa_buf[:63], cast(int) uuid^.most_sig)
		s2 := strconv.itoa(global.g_itoa_buf[64:], cast(int) uuid^.least_sig)
		return strings.concatenate({ s1, s2 })
	} else {
		return ""
	}
}

UUID_from_string :: proc(s: string) -> (UUID)
{
	/*int len = name.length();
        if (len > 36) {
            throw new IllegalArgumentException("UUID string too large");
        } else {
            int dash1 = name.indexOf(45, 0);
            int dash2 = name.indexOf(45, dash1 + 1);
            int dash3 = name.indexOf(45, dash2 + 1);
            int dash4 = name.indexOf(45, dash3 + 1);
            int dash5 = name.indexOf(45, dash4 + 1);
            if (dash4 >= 0 && dash5 < 0) {
                long mostSigBits = Long.parseLong(name, 0, dash1, 16) & 4294967295L;
                mostSigBits <<= 16;
                mostSigBits |= Long.parseLong(name, dash1 + 1, dash2, 16) & 65535L;
                mostSigBits <<= 16;
                mostSigBits |= Long.parseLong(name, dash2 + 1, dash3, 16) & 65535L;
                long leastSigBits = Long.parseLong(name, dash3 + 1, dash4, 16) & 65535L;
                leastSigBits <<= 48;
                leastSigBits |= Long.parseLong(name, dash4 + 1, len, 16) & 281474976710655L;
                return new UUID(mostSigBits, leastSigBits);
            } else {
                throw new IllegalArgumentException("Invalid UUID string: " + name);
            }
    }*/

    return UUID_nil
}