package j_regex
import "core:fmt"
import "core:strings"
import "core:slice"

import "core:unicode/utf8"

import global "mco:odin/global"
import conf "mco:odin/conf"

import j_lang "mco:java/lang"

RegexFlag :: enum uint
{
	UnixLines,
	CaseInsensitive,
	Comments,
	Multiline,
	Literal,
	Dotall,
	UnicodeCase,
	CanonEQ,
	UnicodeCharClass,
}
RegexFlags :: bit_set[RegexFlag]
ALL_FLAGS :: RegexFlags{ .UnixLines, .CaseInsensitive, .Comments, .Multiline, .Literal, .Dotall, .UnicodeCase, .CanonEQ, .UnicodeCharClass }

accept: ^Node
last_accept: ^Node
Pattern_INIT :: proc()
{
	// init accept
	Node_init(accept)

	// init last_accept
	tmp_last := new(LastNode)
	LastNode_init(&tmp_last)
	last_accept = (^Node)(tmp_last)
}

Pattern :: struct
{
	pattern: string,
	flags: RegexFlags,
	flags0: RegexFlags,

	compiled: bool,
	normalized_pattern: string,

	root: ^Node,
	match_root: ^Node,

	buffer: []int,
	predicate: CharPredicate,

	named_groups: map[string]int,

	group_nodes: []GroupHead,
	top_closure_nodes: [dynamic]^Node,

	local_TCN_count: int,
	has_group_ref: bool,
	temp: []rune,

	capturing_group_count: int,
	local_count: int,
	cursor: int,
	pattern_length: int,

	has_supplementary: bool,
}

Pattern_compile_static_noflags :: proc(this: ^Pattern, reg: string)
{
	Pattern_init(this, reg, {})
}
Pattern_compile_static_flags :: proc(this: ^Pattern, reg: string, flags: RegexFlags)
{
	Pattern_init(this, reg, flags)
}
@private
Pattern_compile_nonstatic :: proc(this: ^Pattern)
{
	if Pattern_has(this, { .CanonEQ }) && !Pattern_has(this, { .Literal })
	{
		// this.normalized_pattern = Pattern_normalize(this.pattern)
		panic("Canonical equivalence has not yet been implemented!")
	} else {
		this.normalized_pattern = this.pattern
	}

	this.pattern_length = len(this.normalized_pattern)
	this.temp = make(type_of(this.temp), this.pattern_length + 2)
	this.has_supplementary = false

	count: int = 0
	c: int

	for x: int = 0; x < this.pattern_length; x += j_lang.Char_char_count(c)
	{
		c = j_lang.String_code_point_at(this.normalized_pattern, x)
		if Pattern_is_supplementary(this, c)
		{
			this.has_supplementary = true
		}

		this.temp[count] = c; count += 1
	}

	this.pattern_length = count
	if !Pattern_has(this, { .Literal })
	{
		// Pattern_remove_QE_quoting(this)
	}

	this.buffer = make(type_of(this.buffer), 32)
	this.group_nodes = make([]GroupHead, 10)
	if !(len(this.named_groups) == 0) { clear(&this.named_groups) }
	this.top_closure_nodes = make(type_of(this.top_closure_nodes), 0, 10)

	if Pattern_has(this, { .Literal })
	{
		this.match_root = Pattern_new_slice(this, this.temp, this.pattern_length, this.has_supplementary)
		this.match_root.next = last_accept
	} else
	{
		this.match_root = Pattern_expr(this, last_accept)
		if this.pattern_length != this.cursor
		{
			if Pattern_peek(this) == 41
			{
				global.throw_unchecked({ .Exception }, "Unmatched closing )")
			}

			global.throw_unchecked({ .Exception }, "Unexpected internal error")
		}
	}

	if .Slice in this.match_root.type
	{
		this.root = BnM_optimize(this.match_root)
		if this.root == this.match_root
		{
			this.root = (^Node)(StartS_new_instance(this.match_root)) if this.has_supplementary else (^Node)(Start_new_instance(this.match_root))
		}
	} else if !(.Begin in this.match_root.type) && !(.First in this.match_root.type)
	{
		this.root = (^Node)(StartS_new_instance(this.match_root)) if this.has_supplementary else (^Node)(Start_new_instance(this.match_root))
	} else
	{
		this.root = this.match_root
	}

	if !this.has_group_ref
	{
		for _, i in this.top_closure_nodes
		{
			this_node := this.top_closure_nodes[i]
			if .Loop in this_node.type
			{
				(^Loop)(this_node).pos_index = this.local_TCN_count; this.local_TCN_count += 1
			}
		}
	}

	delete(this.temp); this.temp = nil
	delete(this.buffer); this.buffer = nil
	delete(this.group_nodes); this.group_nodes = nil
	this.pattern_length = 0
	this.compiled = true
	
	// free all nodes
	for n in (this.top_closure_nodes) { free(n) }
	delete(this.top_closure_nodes); this.top_closure_nodes = nil
}
Pattern_compile :: proc{
	Pattern_compile_static_noflags,
	Pattern_compile_static_flags,

	Pattern_compile_nonstatic,
}

@private
Pattern_init :: proc(this: ^Pattern, p: string, f: RegexFlags)
{
	if (f & ~ALL_FLAGS) != {}
	{
		global.throw_unchecked({ .IllegalArgumentException }, fmt.tprintln("Unkown flag provided."))
	}

	this.pattern = p
	this.flags = f

	if (this.flags & { .UnicodeCharClass }) != {}
	{
		this.flags |= RegexFlags{ .UnicodeCase }
	}

	this.flags0 = this.flags

	this.capturing_group_count = 1
	this.local_count = 0
	this.local_TCN_count = 0

	if len(this.pattern) > 0
	{
		Pattern_compile_nonstatic(this)
	} else
	{
		tmp_start := new(Start)
		Start_init(tmp_start, last_accept)
		
		if this.root != nil { free(this.root) }
		this.root = transmute(^Node) tmp_start
		this.match_root = last_accept
	}
}

Pattern_expr :: proc()
{

}

Pattern_new_slice :: proc(this: ^Pattern, buf: []rune, count: int, has_supplementary: bool) -> (^Node)
{
	tmp := make([]rune, count)
	if Pattern_has(this, { .CaseInsensitive })
	{
		if Pattern_has(this, { .UnicodeCase })
		{
			for i := 0; i < count; i += 1
			{
				tmp[i] = j_lang.Char_to_lower(j_lang.Char_to_upper(cast(rune) buf[i]))
			}
			return SliceUS_new_instance(tmp) if has_supplementary else SliceU_new_instance(tmp)
		}
		for i := 0; i < count; i += 1
		{
			tmp[i] = ASCII_to_lower(buf[i])
		}
		return SliceIS_new_instance(tmp) if has_supplementary else SliceI_new_instance(tmp)
	}

	for i := 0; i < count; i += 1
	{
		tmp[i] = buf[i]
	}

	return SliceS_new_instance(tmp) if has_supplementary else Slice_new_instance(tmp)
}

Pattern_has :: #force_inline proc(this: ^Pattern, f: RegexFlags) -> (bool)
{
	return (this.flags0 & f) != {}
}

Pattern_mark :: #force_inline proc(this: ^Pattern, c: rune)
{
	this.temp[this.pattern_length] = c
}

Pattern_peek :: proc(this: ^Pattern) -> (rune)
{
	ch := this.temp[this.cursor]
	if Pattern_has(this, { .Comments })
	{
		ch = Pattern_peek_past_whitespace(this, ch)
	}
	return ch
}

Pattern_peek_past_whitespace :: proc(this: ^Pattern, ch: rune) -> (rune)
{
	ch := ch
	for ASCII_is_space(ch) || ch == '#'
	{
		for ASCII_is_space(ch)
		{
			this.cursor += 1; ch = this.temp[this.cursor]
		}

		if ch == '#'
		{
			ch = Pattern_peek_past_line(this)
		}
	}
	return ch
}

Pattern_peek_past_line :: proc(this: ^Pattern) -> (rune)
{
	this.cursor += 1; ch := this.temp[this.cursor]
	for ch != 0 && !Pattern_is_line_separator(this, ch)
	{
		this.cursor += 1; ch = this.temp[this.cursor]
	}
	return ch
}

Pattern_is_line_separator :: proc(this: ^Pattern, ch: rune) -> (bool)
{
	if Pattern_has(this, { .UnixLines })
	{
		return ch == '\n'
	} else
	{
		return ch == '\n' ||
			ch == '\r' ||
			(ch|1) == 0x2029 ||
			ch == 0x0085
	}
}

Pattern_skip :: proc(this: ^Pattern) -> (rune)
{
	i := this.cursor
	ch := this.temp[i + 1]
	this.cursor = i + 2
	return ch
}

Pattern_unread :: #force_inline proc(this: ^Pattern)
{
	this.cursor -= 1
}










// NODES
NodeType :: enum
{
	BaseNode,
	LastNode,

	Start,
	StartS,

	GroupHead,
	GroupTail,

	Loop,

	First,
	Begin,
	End,

	BnM,
	BnMS,

	SliceNode,
	Slice,
	SliceS,
}
NodeTypes :: bit_set[NodeType]

NodeMatchProc :: #type proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
NodeStudyProc :: #type proc(_this: rawptr, info: ^TreeInfo) -> (bool)

Node :: struct
{
	type: NodeTypes,
	next: ^Node,
	match: NodeMatchProc,
	study: NodeStudyProc,
}

Node_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^Node)(_this)
	matcher.last = i
	matcher.groups[0] = matcher.first
	matcher.groups[1] = matcher.last
	return true
}

Node_study :: proc(_this: rawptr, info: ^TreeInfo) -> (bool)
{
	this := (^Node)(_this)
	if this.next != nil
	{
		return this.next->study(info)
	} else
	{
		return info.deterministic
	}
}

Node_init :: proc(this: ^Node)
{
	this.type += { .BaseNode }

	this.next = accept
	this.match = Node_match
	this.study = Node_study
}







LastNode :: struct
{
	using node: Node,
}

LastNode_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	if matcher.accept_mode == ENDANCHOR && i != matcher.to
	{
		return false
	}
	return #force_inline Node_match(_this, matcher, i, seq)
}

LastNode_init :: proc(this: ^LastNode)
{
	#force_inline Node_init((^Node)(this)) // implicit super()

	this.type += { .LastNode }
	this.match = LastNode_match
}









Start :: struct
{
	using node: Node,
	min_length: int,
}

Start_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^Start)(_this)
	if i > matcher.to - this.min_length
	{
		matcher.hit_end = true
		return false
	}

	i := i
	guard: int = matcher.to - this.min_length
	for ; i <= guard; i += 1
	{
		if this.next.match(rawptr(this.next), matcher, i, seq)
		{
			matcher.first = i
			matcher.groups[0] = matcher.first
			matcher.groups[1] = matcher.last
			return true
		}
	}

	matcher.hit_end = true
	return false
}

Start_study :: proc(_this: rawptr, info: ^TreeInfo) -> (bool)
{
	this := (^Start)(_this)
	this.next->study(info)
	info.max_valid = false
	info.deterministic = false
	return false
}

Start_init :: proc(_this: rawptr, node: ^Node)
{
	this := (^Start)(_this)
	#force_inline Node_init((^Node)(this))

	this.type += { .Start }

	this.next = node
	info: TreeInfo; TreeInfo_init(&info)
	this.next.study(this.next, &info)
	this.min_length = info.min_length

	this.match = Start_match
	this.study = Start_study
}

Start_new_instance :: proc(node: ^Node) -> (this: ^Start)
{
	this = new(Start)
	Start_init(this, node)
	return
}









StartS :: struct
{
	using start: Start,
}

StartS_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^StartS)(_this)
	i := i
	if i > matcher.to - this.min_length
	{
		matcher.hit_end = true
		return false
	} else 
	{
		guard: int = matcher.to - this.min_length

		for i <= guard
		{
			if this.next->match(matcher, i, seq)
			{
				matcher.first = i
				matcher.groups[0] = matcher.first
				matcher.groups[1] = matcher.last
				return true
			}

			if i == guard
			{
				break
			}

			original_i := i
			i += 1
			if j_lang.Char_is_high_surrogate(utf8.rune_at(seq, original_i))
			{
				if i < len(seq) && j_lang.Char_is_low_surrogate(utf8.rune_at(seq, i))
				{
					i += 1
				}
			}
		}

		matcher.hit_end = true
		return false
	}
}

StartS_init :: proc(this: ^StartS, node: ^Node)
{
	Start_init(this, node)

	this.type += { .StartS }

	this.match = StartS_match
}

StartS_new_instance :: proc(node: ^Node) -> (this: ^StartS)
{
	this = new(StartS)
	StartS_init(this, node)
	return
}






BnM :: struct
{
	using node: Node,
	buffer: []int,
	last_occ: []int,
	opto_sft: []int,
}

BnM_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^BnM)(_this)
	i := i
	src := this.buffer
	pattern_length := len(src)
	last := matcher.to - pattern_length

	for
	{
		label26: for i <= last
		{
			for j: int = pattern_length - 1; j >= 0; j -= 1
			{
				ch := utf8.rune_at(seq, i + j)
				if ch != cast(rune) src[j]
				{
					i += max(int(j + 1) - this.last_occ[ch & 127], this.opto_sft[j])
					continue label26
				}
			}

			matcher.first = i
			ret: bool = this.next->match(matcher, i + int(pattern_length), seq)
			if ret
			{
				matcher.first = i
				matcher.groups[0] = matcher.first
				matcher.groups[1] = matcher.last
				return true
			}

			i += 1
		}

		matcher.hit_end = true
		return false
	}
}

BnM_study :: proc(_this: rawptr, info: ^TreeInfo) -> (bool)
{
	this := (^BnM)(_this)
	info.min_length += len(this.buffer)
	info.max_valid = false
	return this.next->study(info)
}

BnM_init :: proc(this: ^BnM, src, last_occ, opto_sft: []int, next: ^Node)
{
	#force_inline Node_init((^Node)(this))

	this.type += { .BnM }

	// Overrides
	this.match = BnM_match
	this.study = BnM_study

	this.buffer = src
	this.last_occ = last_occ
	this.opto_sft = opto_sft
	this.next = next
}

BnM_new_instance :: proc(src, last_occ, opto_sft: []int, next: ^Node) -> (this: ^BnM)
{
	this = new(BnM)
	BnM_init(this, src, last_occ, opto_sft, next)
	return
}

// @Static
BnM_optimize :: proc(node: ^Node) -> (^Node)
{
	if !(.Slice in node.type)
	{
		return node
	}

	src := (^Slice)(node).buffer
	pattern_length: int = len(src)
	if pattern_length < 4
	{
		return node
	}

	last_occ := make([]int, 128)
	opto_sft := make([]int, pattern_length)

	i: int
	for i = 0; i < pattern_length; i += 1
	{
		last_occ[src[i] & 127] = int(i + 1)
	}

	label42: for i = pattern_length; i > 0; i -= 1
	{
		j: int
		for j = pattern_length - 1; j >= i; j -= 1
		{
			if src[j] != src[j - 1]
			{
				continue label42
			}

			opto_sft[j - 1] = int(i)
		}

		for j > 0
		{
			j -= 1
			opto_sft[j] = int(i)
		}
	}

	opto_sft[pattern_length - 1] = 1
	if (.SliceS in node.type)
	{
		return BnMS_new_instance(src, last_occ, opto_sft, node.next)
	}
	return BnM_new_instance(src, last_occ, opto_sft, node.next)
}













BnMS :: struct
{
	using bnm: BnM,
	length_in_chars: int,
}

BnMS_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	// IMPL
	return false
}

BnMS_init :: proc(this: ^BnMS, src, last_occ, opto_sft: []int, next: ^Node)
{
	BnM_init((^BnM)(this), src, last_occ, opto_sft, next)

	this.type += { .BnMS }

	this.match = BnMS_match

	var5 := this.buffer
	var6 := len(var5)

	for i: int = 0; i < var6; i += 1
	{
		cp := var5[i]
		this.length_in_chars += j_lang.Char_char_count(rune(cp))
	}
}

BnMS_new_instance :: proc(src, last_occ, opto_sft: []int, next: ^Node) -> (this: ^BnMS)
{
	this = new(BnMS)
	BnMS_init(this, src, last_occ, opto_sft, next)
	return
}





SliceNode :: struct
{
	using node: Node,
	buffer: []int,
}

SliceNode_init :: proc(this: ^SliceNode, buf: []int)
{
	#force_inline Node_init((^Node)(this))

	this.type += { .SliceNode }

	this.study = SliceNode_study
	this.buffer = buf
}

SliceNode_study :: proc(_this: rawptr, info: ^TreeInfo) -> (bool)
{
	this := (^SliceNode)(_this)
	info.min_length += len(this.buffer)
	info.max_length += len(this.buffer)
	return this.next->study(info)
}







Slice :: struct
{
	using slice_node: SliceNode,
}

Slice_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^Slice)(_this)
	i := i

	buf := this.buffer
	length := len(buf)

	for j: int = 0; j < length; j += 1
	{
		if i + j >= matcher.to
		{
			matcher.hit_end = true
			return false
		}

		if (cast(rune) buf[j]) != utf8.rune_at(seq, int(i + j))
		{
			return false
		}
	}

	return this.next->match(matcher, i + int(length), seq)
}

Slice_init :: proc(this: ^Slice, buf: []int)
{
	SliceNode_init((^SliceNode)(this), buf)

	this.type += { .Slice }

	this.match = Slice_match
}








GroupHead :: struct
{
	using node: Node,
	local_index: int,
	tail: GroupTail,
}

GroupHead_init :: proc(this: ^GroupHead)
{
	#force_inline Node_init((^Node)(this))

	this.type += { .GroupHead }


}





GroupTail :: struct
{
	using node: Node,
	local_index: int,
	group_index: int,
}

GroupTail_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^GroupTail)(_this)
	tmp := matcher.locals[this.local_index]
	if tmp >= 0
	{
		gstart := matcher.groups[this.group_index]
		gend := matcher.groups[this.group_index + 1]

		matcher.groups[this.group_index] = tmp
		matcher.groups[this.group_index + 1] = i
		if this.next->match(matcher, i, seq)
		{
			return true
		}

		matcher.groups[this.group_index] = gstart
		matcher.groups[this.group_index + 1] = gend
		return false
	} else
	{
		matcher.last = i
		return true
	}
}

GroupTail_init :: proc(_this: rawptr, local_count, group_count: int)
{
	this := (^GroupTail)(_this)
	#force_inline Node_init((^Node)(this))

	this.type += { .GroupTail }

	this.local_index = local_count
	this.group_index = group_count + group_count

	this.match = GroupTail_match
}







Loop :: struct
{
	using node: Node,
	body: ^Node,

	count_index, begin_index: int,
	cmin, cmax: int,
	pos_index: int,

	match_init: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool),
}

Loop_match :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^Loop)(_this)
	if i > matcher.locals[this.begin_index]
	{
		count := matcher.locals[this.count_index]
		b: bool
		if count < this.cmin
		{
			matcher.locals[this.count_index] = (count + 1)
			b = this.body->match(matcher, i, seq)
			if !b
			{
				matcher.locals[this.count_index] = (count)
			}

			return b
		}

		if count < this.cmax
		{
			if this.pos_index != -1 && IntHashSet_contains(&matcher.locals_pos[this.pos_index], cast(int) i)
			{
				return this.next->match(matcher, i, seq)
			}

			matcher.locals[this.count_index] = count + 1
			b = this.body->match(matcher, i, seq)
			if b
			{
				return true
			}

			matcher.locals[this.count_index] = count
			if this.pos_index != -1
			{
				IntHashSet_add(&matcher.locals_pos[this.pos_index], cast(int) i)
			}
		}
	}

	return this.next->match(matcher, i, seq)
}

Loop_match_init :: proc(_this: rawptr, matcher: ^Matcher, i: int, seq: string) -> (bool)
{
	this := (^Loop)(_this)
	save := matcher.locals[this.count_index]
	ret := false
	if this.pos_index != -1 && !matcher.locals_pos[this.pos_index].non_nil
	{
		IntHashSet_init(&matcher.locals_pos[this.pos_index])
	}

	if 0 < this.cmin
	{
		matcher.locals[this.count_index] = 1
		ret = this.body->match(matcher, i, seq)
	} else if 0 < this.cmax
	{
		matcher.locals[this.count_index] = 1
		ret = this.body->match(matcher, i, seq)
		if !ret
		{
			ret = this.next->match(matcher, i, seq)
		}
	} else
	{
		ret = this.next->match(matcher, i, seq)
	}

	matcher.locals[this.count_index] = save
	return ret
}

Loop_study :: proc(_this: rawptr, info: ^TreeInfo) -> (bool)
{
	this := (^Loop)(_this)
	info.max_valid = false
	info.deterministic = false
	return false
}

Loop_init :: proc(_this: rawptr, count_index, begin_index: int)
{
	this := (^Loop)(_this)
	#force_inline Node_init((^Node)(this))

	this.type += { .Loop }

	// Overrides
	this.match = Loop_match
	this.study = Loop_study

	this.match_init = Loop_match_init

	this.count_index = count_index
	this.begin_index = begin_index
	this.pos_index = -1
}














QType :: enum
{
	Greedy,
	Lazy,
	Possessive,
	Independent,
}







TreeInfo :: struct
{
	min_length, max_length: int,
	max_valid, deterministic: bool,
}

TreeInfo_init :: proc(this: ^TreeInfo)
{
	TreeInfo_reset(this)
}

TreeInfo_reset :: proc(this: ^TreeInfo)
{
	this.min_length = 0
	this.max_length = 0

	this.max_valid = true
	this.deterministic = true
}