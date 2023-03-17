package j_regex

Matcher :: struct
{
	parent_pattern: ^Pattern,
	groups: []int,
	from, to: int,
	lookbehind_to: int,

	text: string,
	accept_mode: int, // 0
	first: int, // -1
	last: int, // 0
	old_last: int, // -1
	last_append_pos: int, // 0

	locals: []int,
	locals_pos: []IntHashSet,

	hit_end: bool,
	require_end: bool,
	transparent_bounds: bool, // false
	anchoring_bounds: bool, // true

	mod_count: int,
}

ENDANCHOR :: 1
NOANCHOR :: 0

Matcher_init_none :: proc(this: ^Matcher)
{
	this.accept_mode = 0
	this.first = -1
	this.last = 0
	this.old_last = -1
	this.last_append_pos = 0

	this.transparent_bounds = false
	this.anchoring_bounds = true
}

Matcher_init_text :: proc(this: ^Matcher, parent: ^Pattern, text: string)
{
	#force_inline Matcher_init_none(this)

	this.parent_pattern = parent
	this.text = text
	par_group_count: int = max(parent.capturing_group_count, 10)
	this.groups = make([]int, par_group_count * 2)
	this.locals = make([]int, parent.local_count)
	this.locals_pos = make([]IntHashSet, parent.local_TCN_count)

	Matcher_reset(this)
}

Matcher_reset :: proc(this: ^Matcher)
{
	this.first = -1
	this.last = 0
	this.old_last = -1

	i: int
	for i = 0; i < len(this.groups); i += 1
	{
		this.groups[i] = -1
	}

	for i = 0; i < len(this.locals); i += 1
	{
		this.locals[i] = -1
	}

	for i = 0; i < len(this.locals_pos); i += 1
	{
		if this.locals_pos[i] != nil
		{
			IntHashSet_clear(&this.locals_pos[i])
		}
	}

	this.last_append_pos = 0
	this.from = 0
	this.to = Matcher_get_text_length(this)
	this.mod_count += 1
	return this
}

Matcher_match :: proc(this: ^Matcher, from, anchor: int) -> (bool)
{
	this.hit_end = false;
	this.require_end = false
	from = from < 0 ? 0 : from
	this.first = from
	this.old_last = this.old_last < 0 ? from : this.old_last

	i: int
	for i = 0; i < len(this.groups); i += 1
	{
		this.groups[i] = -1
	}

	for i = 0; i < len(this.locals_pos); i += 1
	{
		if this.locals_pos[i] != nil
		{
			IntHashSet_clear(&this.locals_pos[i])
		}
	}

	this.accept_mode = anchor
	result: bool = this.parentPattern.match_root.match(this, from, this.text)
	if !result
	{
		this.first = -1
	}

	this.old_last = this.last
	this.mod_count += 1
	return result
}

Matcher_get_text_length :: proc(this: ^Matcher) -> (int)
{
	return len(this.text)
}