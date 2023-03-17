package mc
import "core:strings"

import j_lang "mco:java/lang"

ClickAction :: enum
{
	OpenURL,
	OpenFile,
	RunCmd,
	SuggestCmd,
	ChangePage,
	CopyToClipboard,
}

ClickActionValue :: struct
{
	name: string,
	allow_from_server: bool,
}

ClickActionData := [ClickAction]ClickActionValue{
	.OpenURL = { "open_url", true },
	.OpenFile = { "open_file", false },
	.RunCmd = { "run_command", true },
	.SuggestCmd = { "suggest_command", true },
	.ChangePage = { "change_page", true },
	.CopyToClipboard = { "copy_to_clipboard", true },
}

ClickAction_hash_code :: proc(this: ClickAction) -> (int)
{
	return int(this)
}

ClickEvent :: struct
{
	action: ClickAction,
	value: string,
}

// @LingeringAlloc
ClickEvent_to_string :: proc(this: ^ClickEvent) -> (string)
{
	//return strings.concatenate({ "ClickEvent{action=", this.action, ", value='", this.value, "'}" })
	return ""
}

ClickEvent_hash_code :: proc(this: ^ClickEvent) -> (int)
{
	i: int = ClickAction_hash_code(this.action)
	return 31 * i + (j_lang.String_hash_code(this.value) if (len(this.value) > 0) else 0)
}

// Hover
HoverAction :: enum
{
	ShowText,
	ShowItem,
	ShowEntity,
}

// TODO(ps4star): IMPL

HoverEvent :: struct
{
	action: HoverAction,
}