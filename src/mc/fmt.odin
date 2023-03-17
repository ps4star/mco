package mc

/*import chat "mco:mc/network/chat"*/

/*
For now I'm going to attempt just replacing this with a string
and see how it goes :P
*/
/*
FmtText :: struct
{
	visit: proc(this: rawptr),
	visit_with_style: proc(this: rawptr, style: ^chat.Style)
}*/

FmtText :: #type proc(this: rawptr, style: ^Style)

// @ChangedName
// @MovedFrom("mc/util")
// "FormattedCharSink"
FmtCharSink :: #type proc(this: rawptr, i1: int, s: ^Style, i2: int)

// @ChangedName
// @MovedFrom("mc/util")
// "FormattedCharSequence"
FmtCharSeq :: #type proc(this: rawptr, sink: ^FmtCharSink)