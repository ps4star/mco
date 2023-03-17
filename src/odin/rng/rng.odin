package odin_rng
import "core:fmt"
import "core:strings"
import "core:math/linalg"

import "../conf"

// This pkg could probably be moved to somewhere in the "java/" tree in the future,
// because this is mostly just a pseudo-replacement for some java.security.* features (atm; TODO: look back at this in the future)
// but having RNG is just generally useful so we're keeping it in odin for now

// This file provides both a Wichmann-hill and xorshift128+ non-noise PRNG implementation
// Only 1 can be used, and this is toggle-able with a -definition flag in the compiler flags
// By default, xorshift128+ is used due to its higher speed, but Wichmann-hill is generally higher quality

WHRNGState :: struct
{
	a, b, c: i32,
}

XSRNGState :: [2]u64

when conf.RNG_ALGORITHM == conf.RNG_WH {
	g_rng := WHRNGState{ 100, 100, 100 }

	MOD_A :: 30_269
	MOD_B :: 30_307
	MOD_C :: 30_323

	update :: #force_inline proc()
	{
		g_rng.a = (171 * g_rng.a) % MOD_A
		g_rng.b = (172 * g_rng.b) % MOD_B
		g_rng.c = (170 * g_rng.c) % MOD_C
	}

	random :: #force_inline proc() -> (f32)
	{
		res := (g_rng.a / f32(MOD_A)) + (g_rng.b / f32(MOD_B)) + (g_rng.c / f32(MOD_C))
		return res - linalg.floor(res)
	}
} else when conf.RNG_ALGORITHM == conf.RNG_XS {
	g_rng := XSRNGState{100, 100}

	update :: #force_inline proc()
	{
		t := g_rng[0]
		s := g_rng[1]

		g_rng[0] = s
		t ~= (t << 23)
		t ~= (t >> 18)
		t ~= s ~ (s >> 5)
		g_rng[1] = t
	}

	random :: #force_inline proc() -> (f32)
	{
		res := f32(g_rng[0] + g_rng[1]) / 1.909237
		return res - linalg.floor(res)
	}
} else {
	#panic(conf.PANIC_MSG + "RNG_ALGORITHM != WICHMANN_HILL|XORSHIFT128PLUS")
}

// Returns an array of random bytes of constant length
random_bytes :: proc($length: int) -> ([length]byte)
{
	out: [length]byte
	for i in 0..<length {
		update()
		rand := random()
		out[i] = byte(linalg.floor(rand * 256))
	}
	return out
}