package mc

AbstractClientPlayer :: struct
{
	client_level: ClientLevel,
}

AbstractClientPlayer_init :: proc(this: ^AbstractClientPlayer, cl: ^ClientLevel, cpl: ^ClientPacketListener)
{
	// super(p_234112_, p_234112_.getSharedSpawnPos(), p_234112_.getSharedSpawnAngle(), p_234113_, p_234114_);
	this.client_level = cl^
}




LocalPlayer :: struct
{
	using abstract: AbstractClientPlayer,

	connection: ClientPacketListener,
	stats: StatsCounter,
	recipe_book: ClientRecipeBook,
	permission_level: int, // @StaticDefault (0)
	x_last, y_last_1, z_last: f64,
	y_rot_last, x_rot_last: f32,
	last_on_ground, crouching: bool,
	was_shift_down: bool,
	was_sprinting: bool,
	position_reminder: int,
	flash_on_set_health: bool,

	server_brand: string,
	input: Input,
	minecraft: ^Minecraft,
	sprint_trig_time: int,
	sprint_time: int,

	y_bob, x_bob, y_bob_0, x_bob_0: f32,
	jump_riding_ticks: int,
	jump_riding_scale: f32,
	portal_time, o_portal_time: f32,
	started_using_item: bool,

	using_item_hand: InteractionHand,
	hands_busy: bool,
	auto_jump_enabled: bool, // @StaticDefault (true)
	auto_jump_time: int,
	was_fall_flying: bool,
	water_vision_time: int,
	show_death_screen: bool, // @StaticDefault (true)
}

// Minecraft p_108621_, ClientLevel p_108622_,
// ClientPacketListener p_108623_, StatsCounter p_108624_,
// ClientRecipeBook p_108625_, boolean p_108626_, boolean p_108627_
LocalPlayer_init :: proc(this: ^LocalPlayer,
	minecraft: ^Minecraft,
	cl: ^ClientLevel,
	cpl: ^ClientPacketListener,
	sc: ^StatsCounter,
	crb: ^ClientRecipeBook,
	flag1, flag2: bool)
{
	// super(p_108622_, p_108623_.getLocalGameProfile(), p_108621_.getProfileKeyPairManager().profilePublicKey().orElse((ProfilePublicKey)null));
	AbstractClientPlayer_init(&(this.abstract),
		cl,
		cpl)

	this.minecraft = minecraft
	this.connection = cpl^
	this.stats = sc^
	this.recipe_book = crb^
	this.was_shift_down = flag1
	this.was_sprinting = flag2
}