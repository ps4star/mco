package mc
import j_misc "mco:java/misc"

import blaze "mco:extern/com_mojang/blaze3d"

// @Obsolete
// VirtualScreen
/*VirtualScreen :: struct
{
	mc: ^Minecraft,
	smgr: blaze.ScreenManager,
}

VirtualScreen_init :: proc(this: ^VirtualScreen, mc: ^Minecraft)
{
	this.mc = mc
	blaze.ScreenManager_init(&(this.smgr))
}

VirtualScreen_new_instance :: #force_inline proc(mc: ^Minecraft) -> (this: ^VirtualScreen)
{
	this = new(VirtualScreen)
	VirtualScreen_init(this, mc)
	return
}*/





// Other screens (unrelated to above)
@private ALLOWED_PROTOCOLS := []string{ "http", "https" }
@private EXTRA_SPACE_AFTER_FIRST_TOOLTIP_LINE :: 2
@private USAGE_NARRATION: ^Component

Screen :: struct
{
	minecraft: ^Minecraft,
	title: ^Component,
	width, height: int,

	narration_suppress_time, next_narration_time: i64,
	item_renderer: ^ItemRenderer,

	font: Font,

	// Methods
	get_narration_message: proc(rawptr) -> (^Component),
	render: proc(rawptr),
	key_pressed: proc(rawptr, i1, i2, i3: int) -> (bool),
	should_close_on_esc: proc(rawptr) -> (bool),
	on_close: proc(rawptr),

	render_tooltip: proc(rawptr),
	insert_text: proc(rawptr),
	handle_component_clicked: proc(rawptr) -> (bool),

	init: proc(rawptr),
	tick: proc(rawptr),
	removed: proc(rawptr),
	// render_bg: proc(rawptr, ps: PoseStack),
	is_pause_screen: proc(rawptr) -> (bool),
	resize: proc(rawptr, ^Minecraft, int, int),
	on_files_drop: proc(rawptr, [dynamic]string),
}

Screen_init :: proc(this: ^Screen, c: ^Component)
{
	this.title = c
	this.narration_suppress_time = j_misc.LONG_MIN_VALUE
	this.next_narration_time = j_misc.LONG_MAX_VALUE
}

NARRATE_SUPPRESS_AFTER_INIT_TIME :: 2_000
Screen_initialize :: proc(this: ^Screen, minecraft: ^Minecraft, x, y: int)
{
	this.minecraft = minecraft
	this.item_renderer = &(minecraft.item_renderer)
	this.font = minecraft.font
	this.width = x
	this.height = y

	Screen_rebuild_widgets(this)
	Screen_trigger_immediate_narration(this, false)
	Screen_suppress_narration(this, NARRATE_SUPPRESS_AFTER_INIT_TIME)
}

Screen_resize :: proc(this: ^Screen, minecraft: ^Minecraft, x, y: int)
{
	Screen_initialize(this, minecraft, x, y)
}

Screen_rebuild_widgets :: proc(this: ^Screen)
{
	Screen_clear_widgets(this)
	Screen_set_focused(this)
	this->init()
}

Screen_clear_widgets :: proc(this: ^Screen)
{

}

Screen_set_focused :: proc(this: ^Screen)
{

}

Screen_trigger_immediate_narration :: proc(this: ^Screen, b: bool)
{

}

Screen_suppress_narration :: proc(this: ^Screen, time: i64)
{

}

@private DEMO_LEVEL_ID : string : "Demo_World"
COPYRIGHT_TEXT: ^Component
TitleScreen :: struct
{
	using common: Screen,
	/*private static final String DEMO_LEVEL_ID = "Demo_World";
   public static final Component COPYRIGHT_TEXT = Component.literal("Copyright Mojang AB. Do not distribute!");
   public static final CubeMap CUBE_MAP = new CubeMap(new ResourceLocation("textures/gui/title/background/panorama"));
   private static final ResourceLocation PANORAMA_OVERLAY = new ResourceLocation("textures/gui/title/background/panorama_overlay.png");
   private static final ResourceLocation ACCESSIBILITY_TEXTURE = new ResourceLocation("textures/gui/accessibility.png");
   private final boolean minceraftEasterEgg;
   @Nullable
   private String splash;
   private Button resetDemoButton;
   private static final ResourceLocation MINECRAFT_LOGO = new ResourceLocation("textures/gui/title/minecraft.png");
   private static final ResourceLocation MINECRAFT_EDITION = new ResourceLocation("textures/gui/title/edition.png");
   private Screen realmsNotificationsScreen;
   private final PanoramaRenderer panorama = new PanoramaRenderer(CUBE_MAP);
   private final boolean fading;
   private long fadeInStart;
   @Nullable
   private TitleScreen.WarningLabel warningLabel;*/
}

OutOfMemoryScreen :: struct
{
	using screen: Screen,
}

OutOfMemoryScreen_init :: proc(this: ^OutOfMemoryScreen)
{
	Screen_init((^Screen)(this), Component_translatable("outOfMemory.error"))
}

OutOfMemoryScreen_new_instance :: proc() -> (this: ^OutOfMemoryScreen)
{
	this = new(OutOfMemoryScreen)
	OutOfMemoryScreen_init(this)
	return
}



Screens_INIT :: proc()
{
	USAGE_NARRATION = Component_translatable("narrator.screen.usage")
	COPYRIGHT_TEXT = Component_literal("Copyright Mojang AB. Do not distribute!")
}