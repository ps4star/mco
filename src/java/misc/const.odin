package j_misc
import "core:math/bits"

LONG_MIN_VALUE :: bits.I64_MIN
LONG_MAX_VALUE :: bits.I64_MAX

DOUBLE_MIN_VALUE :: f64(bits.I64_MIN)
DOUBLE_MAX_VALUE :: f64(bits.I64_MAX)

FLOAT_NAN := transmute(f32) (u32(0x7fc00000))