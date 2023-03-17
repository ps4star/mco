package mc

import global "mco:odin/global"
import conf "mco:odin/conf"

import "mco_com_mojang:datafixerupper/serialization"

// Multi-file including:
// - Components
// - ComponentContents
// - contents/*Contents

EmptyContents :: struct {}
LiteralContents :: string

@private SCORER_PLACEHOLDER : string : "*"
ScoreContents :: struct
{
	name: string,
	selector: ^EntitySelector,
	objective: string,
}

ScoreContents_init_from_string :: proc(cont: ^ScoreContents, name, obj: string)
{
	cont.name = name
	//cont.selector = parse_selector(name)
	// TODO(ps4star): define parse_selector
	cont.objective = obj
}

ComponentContents :: union
{
	EmptyContents,
	LiteralContents, // string
	ScoreContents,
	// KeybindContents,
	// NbtContents,
	// SelectorContents,
	TranslatableContents,
}

ComponentContents_EMPTY: ComponentContents = EmptyContents{}







// Merged concept with MutableComponent since it's the only extender
Component :: struct
{
	contents: ComponentContents,
	style: Style,
	visual_order_text: FmtCharSeq,

	// Unused when USE_COMPONENT_CACHING OFF
	/*pool_index: int,*/
}
//MutableComponent :: Component
//ComponentList :: [dynamic]Component

/*when conf.USE_COMPONENT_CACHING == conf.YES {
	// Component cache system
	@private ComponentCachePool :: struct
	{
		origin_lang: mc_locale.LocaleString,
		p: [dynamic]Component,
	}

	@private pool := ComponentCachePool{
		origin_lang = mc_locale.DEFAULT_LOCALE,
		p = [dynamic]Component{},
	}
}*/

Component_init :: proc(this: ^Component, contents: ComponentContents, s: Style)
{
	this.contents = contents
	this.style = s
}

// @LingeringAlloc
Component_new_instance :: proc(contents: ComponentContents, s: Style) -> (out: ^Component)
{
	out = new(Component)
	#force_inline Component_init(out, contents, s)

	/*when conf.USE_COMPONENT_CACHING == conf.YES {
		append(&pool.p, out)
		out.pool_index = len(pool) - 1
	}*/
	return
}

// @LingeringAlloc
Component_new_instance_from_literal :: proc(comp: ^Component, lit: string) -> (out: ^Component)
{
	out = Component_create((LiteralContents)(lit))
	return
}

// @MergedInheritorMethodToBase (MutableComponent_create)
// @LingeringAlloc
Component_create :: proc(contents: ComponentContents) -> (^Component)
{
	return Component_new_instance(contents, Style_EMPTY)
}

// @LingeringAlloc
// @Static
Component_translatable_lit :: proc(str: string) -> (^Component)
{
	tmp_tc: TranslatableContents
	TranslatableContents_init(&tmp_tc, str)
	return Component_create(tmp_tc)
}

// @LingeringAlloc
// @Static
Component_translatable_args :: proc(str: string, args: TCArgsType) -> (^Component)
{
	tmp_tc: TranslatableContents
	TranslatableContents_init(&tmp_tc, str, args)
	return Component_create(tmp_tc)
}

// @LingeringAlloc
// @Static
Component_translatable :: proc{
	Component_translatable_lit,
	Component_translatable_args,
}

Component_literal :: #force_inline proc(str: string) -> (^Component)
{
	return Component_create(LiteralContents(str))
}

Component_empty :: proc() -> (^Component)
{
	return Component_create(ComponentContents_EMPTY)
}




CommonComponent :: enum
{
	Empty,

	OptionOn,
	OptionOff,

	GuiDone,
	GuiCancel,
	GuiYes,
	GuiNo,
	GuiProceed,
	GuiBack,

	ConnectFailed,

	NewLine,
	NarrationSeparator,
}

// @UserImmutable
common_components := [CommonComponent]^Component{}
Components_INIT :: proc()
{
	this := &(common_components)

	this[.Empty] = Component_empty()

	this[.OptionOn] = Component_translatable("options.on")
	this[.OptionOff] = Component_translatable("options.off")
	this[.GuiDone] = Component_translatable("gui.done")
	this[.GuiCancel] = Component_translatable("gui.cancel")
	this[.GuiYes] = Component_translatable("gui.yes")
	this[.GuiNo] = Component_translatable("gui.no")
	this[.GuiProceed] = Component_translatable("gui.proceed")
	this[.GuiBack] = Component_translatable("gui.back")
	this[.ConnectFailed] = Component_translatable("connect.failed")

	this[.NewLine] = Component_literal("\n")
	this[.NarrationSeparator] = Component_literal(". ")
}