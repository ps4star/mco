package j_regex
import "core:fmt"
import "core:strings"

import global "mco:odin/global"
import conf "mco:odin/conf"

import j_misc "mco:java/misc"
import j_lang "mco:java/lang"

// @DirectClassImplementation
// IntHashSet
IntHashSet :: struct
{
	non_nil: bool,
	entries: []int,
	hashes: []int,
	pos: int,
}

IntHashSet_init :: proc(this: ^IntHashSet)
{
	this.non_nil = true
	this.entries = make([]int, 16 << 1)
	this.hashes = make([]int, (16 / 2) | 1)

	j_misc.fill_slice(this.entries, -1)
	j_misc.fill_slice(this.hashes, -1)

	this.pos = 0
}

IntHashSet_contains :: proc(this: ^IntHashSet, i: int) -> (bool)
{
	h: int = this.hashes[i % len(this.hashes)]
	for h != -1
	{
		if this.entries[h] == i
		{
			return true
		}

		h = this.entries[i + 1]
	}
	return false
}

IntHashSet_add :: proc(this: ^IntHashSet, i: int)
{
	h0: int = i % len(this.hashes)
	next: int = this.hashes[h0]

	next0 := next
	for next0 != -1
	{
		if this.entries[next0 ] == i
		{
			return
		}

		next0 = this.entries[next0 + 1]
	}

	this.hashes[h0] = this.pos
	this.entries[this.pos] = i; this.pos += 1
	this.entries[this.pos] = next; this.pos += 1
	if this.pos == len(this.entries)
	{
		expand(this)
	}
}

IntHashSet_clear :: proc(this: ^IntHashSet)
{
	j_misc.fill_slice(this.entries, -1)
	j_misc.fill_slice(this.hashes, -1)
	this.pos = 0
}

@private
expand :: proc(this: ^IntHashSet)
{
	old := this.entries
	es := make([]int, len(old) << 1)

	hlen: int = (len(old) / 2) | 1
	hs := make([]int, (len(old) / 2) | 1)

	j_misc.fill_slice(es, -1)
	j_misc.fill_slice(hs, -1)

	for n: int = 0; n < this.pos;
	{
		i: int = old[n]
		hsh: int = i % hlen
		next: int = hs[hsh]
		hs[hsh] = n
		es[n] = i; n += 1
		es[n] = next; n += 1
	}

	if this.entries != nil && this.hashes != nil
	{
		delete(this.entries)
		delete(this.hashes)
	}

	this.entries = es
	this.hashes = hs
}





// @DirectClassImplementation
// Grapheme
// @Static
@private
rules: [LAST_TYPE + 1][LAST_TYPE + 1]bool

OTHER :: 0
CR :: 1
LF :: 2
CONTROL :: 3
EXTEND :: 4
RI :: 5
PREPEND :: 6
SPACINGMARK :: 7
L :: 8
V :: 9
T :: 10
LV :: 11
LVT :: 12

FIRST_TYPE :: 0
LAST_TYPE :: 12

Grapheme_INIT :: proc()
{
	for i: int = FIRST_TYPE; i <= LAST_TYPE; i += 1
	{
		for j: int = FIRST_TYPE; j <= LAST_TYPE; j += 1
		{
			rules[i][j] = true
		}
	}

	rules[L][L] = false
	rules[L][V] = false
	rules[L][LV] = false
	rules[L][LVT] = false
	rules[LV][V] = false
	rules[LV][T] = false
	rules[V][V] = false
	rules[V][T] = false

	rules[LVT][T] = false
	rules[T][T] = false

	rules[RI][RI] = false

	for i: int = FIRST_TYPE; i <= LAST_TYPE; i += 1
	{
		rules[i][EXTEND] = false
		rules[i][SPACINGMARK] = false
		rules[PREPEND][i] = false
	}

	for i: int = FIRST_TYPE; i <= LAST_TYPE; i += 1
	{
		for j: int = CR; j <= CONTROL; j += 1
		{
			rules[i][j] = true
			rules[j][i] = true
		}
	}

	rules[CR][LF] = false

}

SYLLABLE_BASE :: 0xAC00
LCOUNT :: 19
VCOUNT :: 21
TCOUNT :: 28
NCOUNT :: VCOUNT * TCOUNT // 588
SCOUNT :: LCOUNT * NCOUNT // 11172

Grapheme_is_boundary :: proc(cp1, cp2: rune) -> (bool)
{
	return rules[get_type(cp1)][get_type(cp2)]
}

@private
is_excluded_spacing_mark :: proc(cp: rune) -> (bool)
{
	return  cp == 0x102B || cp == 0x102C || cp == 0x1038 ||
		cp >= 0x1062 && cp <= 0x1064 ||
		cp >= 0x1062 && cp <= 0x106D ||
		cp == 0x1083 ||
		cp >= 0x1087 && cp <= 0x108C ||
		cp == 0x108F ||
		cp >= 0x109A && cp <= 0x109C ||
		cp == 0x1A61 || cp == 0x1A63 || cp == 0x1A64 ||
		cp == 0xAA7B || cp == 0xAA7D
}

@private
get_type :: proc(cp: rune) -> (int)
{
	type: int = j_lang.Char_get_type(cp)
	switch type
	{
	case j_lang.CONTROL:
		if cp == 0x00D
		{
			return CR
		}

		if cp == 0x000A
		{
			return LF
		}
		return CONTROL
	case j_lang.UNASSIGNED:
		if cp == 0x0378
		{
			return OTHER
		}

	case j_lang.LINE_SEPARATOR, j_lang.PARAGRAPH_SEPARATOR, j_lang.SURROGATE:
		return CONTROL

	case j_lang.FORMAT:
		if cp == 0x200C || cp == 0x200D
		{
			return EXTEND
		}

	case j_lang.NON_SPACING_MARK, j_lang.ENCLOSING_MARK:
		return EXTEND

	case j_lang.COMBINING_SPACING_MARK:
		if is_excluded_spacing_mark(cp)
		{
			return OTHER
		}
		return SPACINGMARK

	case j_lang.OTHER_SYMBOL:
		if cp >= 0x1F1E6 && cp <= 0x1F1FF
		{
			return RI
		}
		return OTHER

	case j_lang.MODIFIER_LETTER:
		if cp == 0xFF9E || cp == 0xFF9F
		{
			return EXTEND
		}
		return OTHER

	case j_lang.OTHER_LETTER:
		if cp == 0x0E33 || cp == 0x0EB3
		{
			return SPACINGMARK
		}

		if cp >= 0x1100 && cp <= 0x11FF
		{
			if cp <= 0x115F
			{
				return L
			}

			if cp <= 0x11A7
			{
				return V
			}

			return T
		}

		sindex: rune = cp - SYLLABLE_BASE
		if sindex >= 0 && sindex < SCOUNT
		{
			if sindex % TCOUNT == 0
			{
				return LV
			}
			return LVT
		}

		if cp >= 0xA960 && cp <= 0xA97C
		{
			return L
		}

		if cp >= 0xD7B0 && cp <= 0xD7C6
		{
			return V
		}

		if cp >= 0xD7CB && cp <= 0xD7FB
		{
			return T
		}
	}
	return OTHER
}







// ASCII
UPPER   :: 0x00000100
LOWER   :: 0x00000200
DIGIT   :: 0x00000400
SPACE   :: 0x00000800
PUNCT   :: 0x00001000
CNTRL   :: 0x00002000
BLANK   :: 0x00004000
HEX     :: 0x00008000
UNDER   :: 0x00010000
ASCII   :: 0x0000FF00
ALPHA   :: (UPPER|LOWER)
ALNUM   :: (UPPER|LOWER|DIGIT)
GRAPH   :: (PUNCT|UPPER|LOWER|DIGIT)
WORD    :: (UPPER|LOWER|UNDER|DIGIT)
XDIGIT  :: (HEX)

@private
ctype := [?]rune{
	CNTRL,                  /* 00 (NUL) */
	CNTRL,                  /* 01 (SOH) */
	CNTRL,                  /* 02 (STX) */
	CNTRL,                  /* 03 (ETX) */
	CNTRL,                  /* 04 (EOT) */
	CNTRL,                  /* 05 (ENQ) */
	CNTRL,                  /* 06 (ACK) */
	CNTRL,                  /* 07 (BEL) */
	CNTRL,                  /* 08 (BS)  */
	SPACE+CNTRL+BLANK,      /* 09 (HT)  */
	SPACE+CNTRL,            /* 0A (LF)  */
	SPACE+CNTRL,            /* 0B (VT)  */
	SPACE+CNTRL,            /* 0C (FF)  */
	SPACE+CNTRL,            /* 0D (CR)  */
	CNTRL,                  /* 0E (SI)  */
	CNTRL,                  /* 0F (SO)  */
	CNTRL,                  /* 10 (DLE) */
	CNTRL,                  /* 11 (DC1) */
	CNTRL,                  /* 12 (DC2) */
	CNTRL,                  /* 13 (DC3) */
	CNTRL,                  /* 14 (DC4) */
	CNTRL,                  /* 15 (NAK) */
	CNTRL,                  /* 16 (SYN) */
	CNTRL,                  /* 17 (ETB) */
	CNTRL,                  /* 18 (CAN) */
	CNTRL,                  /* 19 (EM)  */
	CNTRL,                  /* 1A (SUB) */
	CNTRL,                  /* 1B (ESC) */
	CNTRL,                  /* 1C (FS)  */
	CNTRL,                  /* 1D (GS)  */
	CNTRL,                  /* 1E (RS)  */
	CNTRL,                  /* 1F (US)  */
	SPACE+BLANK,            /* 20 SPACE */
	PUNCT,                  /* 21 !     */
	PUNCT,                  /* 22 "     */
	PUNCT,                  /* 23 #     */
	PUNCT,                  /* 24 $     */
	PUNCT,                  /* 25 %     */
	PUNCT,                  /* 26 &     */
	PUNCT,                  /* 27 '     */
	PUNCT,                  /* 28 (     */
	PUNCT,                  /* 29 )     */
	PUNCT,                  /* 2A *     */
	PUNCT,                  /* 2B +     */
	PUNCT,                  /* 2C ,     */
	PUNCT,                  /* 2D -     */
	PUNCT,                  /* 2E .     */
	PUNCT,                  /* 2F /     */
	DIGIT+HEX+0,            /* 30 0     */
	DIGIT+HEX+1,            /* 31 1     */
	DIGIT+HEX+2,            /* 32 2     */
	DIGIT+HEX+3,            /* 33 3     */
	DIGIT+HEX+4,            /* 34 4     */
	DIGIT+HEX+5,            /* 35 5     */
	DIGIT+HEX+6,            /* 36 6     */
	DIGIT+HEX+7,            /* 37 7     */
	DIGIT+HEX+8,            /* 38 8     */
	DIGIT+HEX+9,            /* 39 9     */
	PUNCT,                  /* 3A :     */
	PUNCT,                  /* 3B ;     */
	PUNCT,                  /* 3C <     */
	PUNCT,                  /* 3D =     */
	PUNCT,                  /* 3E >     */
	PUNCT,                  /* 3F ?     */
	PUNCT,                  /* 40 @     */
	UPPER+HEX+10,           /* 41 A     */
	UPPER+HEX+11,           /* 42 B     */
	UPPER+HEX+12,           /* 43 C     */
	UPPER+HEX+13,           /* 44 D     */
	UPPER+HEX+14,           /* 45 E     */
	UPPER+HEX+15,           /* 46 F     */
	UPPER+16,               /* 47 G     */
	UPPER+17,               /* 48 H     */
	UPPER+18,               /* 49 I     */
	UPPER+19,               /* 4A J     */
	UPPER+20,               /* 4B K     */
	UPPER+21,               /* 4C L     */
	UPPER+22,               /* 4D M     */
	UPPER+23,               /* 4E N     */
	UPPER+24,               /* 4F O     */
	UPPER+25,               /* 50 P     */
	UPPER+26,               /* 51 Q     */
	UPPER+27,               /* 52 R     */
	UPPER+28,               /* 53 S     */
	UPPER+29,               /* 54 T     */
	UPPER+30,               /* 55 U     */
	UPPER+31,               /* 56 V     */
	UPPER+32,               /* 57 W     */
	UPPER+33,               /* 58 X     */
	UPPER+34,               /* 59 Y     */
	UPPER+35,               /* 5A Z     */
	PUNCT,                  /* 5B [     */
	PUNCT,                  /* 5C \     */
	PUNCT,                  /* 5D ]     */
	PUNCT,                  /* 5E ^     */
	PUNCT|UNDER,            /* 5F _     */
	PUNCT,                  /* 60 `     */
	LOWER+HEX+10,           /* 61 a     */
	LOWER+HEX+11,           /* 62 b     */
	LOWER+HEX+12,           /* 63 c     */
	LOWER+HEX+13,           /* 64 d     */
	LOWER+HEX+14,           /* 65 e     */
	LOWER+HEX+15,           /* 66 f     */
	LOWER+16,               /* 67 g     */
	LOWER+17,               /* 68 h     */
	LOWER+18,               /* 69 i     */
	LOWER+19,               /* 6A j     */
	LOWER+20,               /* 6B k     */
	LOWER+21,               /* 6C l     */
	LOWER+22,               /* 6D m     */
	LOWER+23,               /* 6E n     */
	LOWER+24,               /* 6F o     */
	LOWER+25,               /* 70 p     */
	LOWER+26,               /* 71 q     */
	LOWER+27,               /* 72 r     */
	LOWER+28,               /* 73 s     */
	LOWER+29,               /* 74 t     */
	LOWER+30,               /* 75 u     */
	LOWER+31,               /* 76 v     */
	LOWER+32,               /* 77 w     */
	LOWER+33,               /* 78 x     */
	LOWER+34,               /* 79 y     */
	LOWER+35,               /* 7A z     */
	PUNCT,                  /* 7B {     */
	PUNCT,                  /* 7C |     */
	PUNCT,                  /* 7D }     */
	PUNCT,                  /* 7E ~     */
	CNTRL,                  /* 7F (DEL) */
}

ASCII_get_type :: proc(ch: rune) -> (rune)
{
	return (ctype[ch] if (ch & 0xFFFFFF80) == 0 else 0)
}

ASCII_is_type :: proc(ch, type: rune) -> (bool)
{
	return (ASCII_get_type(ch) & type) != 0
}

ASCII_is_space :: proc(ch: rune) -> (bool)
{
	return ASCII_is_type(ch, SPACE)
}

ASCII_is_upper :: proc(ch: rune) -> (bool)
{
	return ((ch-'A')|('Z'-ch)) >= 0
}

ASCII_to_lower :: proc(ch: rune) -> (rune)
{
	return (ch + 0x20) if ASCII_is_upper(ch) else ch
}





CharPredicate :: #type proc(rawptr, int) -> (bool)