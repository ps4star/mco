package mc
import "core:strings"
import "core:fmt"
import odin_os "core:os"

import conf "mco:odin/conf"

import blaze "mco:extern/com_mojang/blaze3d"
import cm_df "mco:extern/com_mojang/datafixerupper"

import "mco:extern/com_mojang/logging"
import prop "mco:extern/com_mojang/authlib/properties"

import "mco:odin/global"
import j_io "mco:java/io"
import j_net "mco:java/net"
import j_lang "mco:java/lang"
import j_func "mco:java/util/function"
import j_util "mco:java/util"

import mc_common "mco:mc/common"

// Static vars
Minecraft_INST: ^Minecraft

@(private="file")
glog := &logging.g_logger

Minecraft_ON_OSX :: true when ODIN_OS == .Darwin else false
Minecraft_MAX_TICKS_PER_UPDATE :: 10

Minecraft_DEFAULT_FONT: ResourceLocation /*:= ResourceLocation_resolve("default")*/
Minecraft_UNIFORM_FONT: ResourceLocation /*:= ResourceLocation_resolve("uniform")*/
Minecraft_ALT_FONT: ResourceLocation /*:= ResourceLocation_resolve("alt")*/

Minecraft_REGIONAL_COMPLIANCES: ResourceLocation /*:= global.resolve("regional_compliancies.json")*/
// TODO: figure out this "CompletableFuture" stuff
// Minecraft_RESOURCE_RELOAD_INITIAL_TASK := CompletableFuture() // ???

Minecraft_INIT :: proc()
{
	Minecraft_DEFAULT_FONT = ResourceLocation_new("default")
	Minecraft_UNIFORM_FONT = ResourceLocation_new("uniform")
	Minecraft_ALT_FONT = ResourceLocation_new("alt")

	Minecraft_REGIONAL_COMPLIANCES = ResourceLocation_new("regional_compliancies.json")
}

Minecraft :: struct
{
	rb_evtloop: ReentrantBlockableEventLoop(j_lang.Runnable), // @Inherited

	res_pack_dir: j_io.File,
	profile_props: prop.PropertyMap,
	tex_mgr: TextureManager,
	fixer_upper: cm_df.DataFixer,
	/*virtual_screen: VirtualScreen,*/ smgr: blaze.ScreenManager,
	window: blaze.Window,
	window_active: bool,
	// timer: Timer,
	// render_bufs: RenderBuffers,
	// lv_renderer: LevelRenderer,
	// ent_render_dispatcher: EntityRenderDispatcher,
	item_renderer: ItemRenderer,
	// particle_engine: ParticleEngine,
	// search_registry: SearchRegistry,
	user: User,
	// font: Font,
	// game_renderer: GameRenderer,
	// debug_renderer: DebugRenderer,
	// progress_listener: StoringChunkProgressListener,
	// gui: Gui,
	// options: Options,
	// hbar_mgr: HotbarManager,
	mouse_handler: MouseHandler,
	// keyboard_handler: KeyboardHandler,
	game_dir: j_io.File,
	launched_version: string,
	version_type: string,
	proxy: j_net.Proxy,

	// ...
	game_renderer: GameRenderer,

	// ...
	render_target: blaze.RenderTarget,

	// ...
	options: Options,

	// ...
	progress_tasks: [dynamic]j_lang.Runnable,

	// ...
	game_thread: ^j_lang.Thread,

	// ...
	font: Font,
	font_mgr: FontManager,

	// ...
	running: bool,

	// ...
	timer: Timer,

	level_renderer: LevelRenderer,

	// ...
	profile_key_mgr: ProfileKeyPairManager,

	// ...
	main_render_target: blaze.RenderTarget,

	// ...
	frames: int,
	no_render: bool,
	screen: Maybe(Screen),
	overlay: Maybe(LoadingOverlay),
	connected_to_realms: bool,

	// ...
	delayed_crash: j_func.Supplier(^CrashReport),

	// ...
	client_pack_source: ClientPackSource,

	// ...
	resmgr: ResourceManager,

	// ...
	entity_render_dispatcher: EntityRenderDispatcher,

	// ...
	render_buffers: RenderBuffers,

	// ...
	single_player_server: Maybe(IntegratedServer),

	// ...
	player: Maybe(LocalPlayer),

	// ...
	pending_reload: bool,

	// ...
	profiler: Profiler,
	fps_pie_render_ticks: int,
	fps_pie_profiler: ContinuousProfiler,

	// ...
	right_click_delay: int,

	// ...
	pause: bool, // @Volatile
	pause_partial_tick: f32,
	gui: Gui,

	// ...
	camera_ent: Maybe(Entity),

	// ...
	game_mode: Maybe(MultiPlayerGameMode),

	// ...
	level: Maybe(ClientLevel),

	// ...
	crosshair_pick_entity: Maybe(Entity),

	// ...
	demo: bool,
}

// @TrivialGetterOrSetter
Minecraft_is_window_active :: #force_inline proc(this: ^Minecraft) -> (bool)
{
	return this.window_active
}

// @TrivialGetterOrSetter
// @SubintProc
Minecraft_set_window_active :: #force_inline proc(this: ^Minecraft, b: bool)
{
	this.window_active = b
}

// @SubintProc
Minecraft_resize_display :: proc(this: ^Minecraft)
{
	/*int i = this.window.calculateScale(this.options.guiScale().get(), this.isEnforceUnicode());
      this.window.setGuiScale((double)i);
      if (this.screen != null) {
         this.screen.resize(this, this.window.getGuiScaledWidth(), this.window.getGuiScaledHeight());
      }

      RenderTarget rendertarget = this.getMainRenderTarget();
      rendertarget.resize(this.window.getWidth(), this.window.getHeight(), ON_OSX);
      this.gameRenderer.resize(this.window.getWidth(), this.window.getHeight());
	this.mouseHandler.setIgnoreFirstMove();*/
	i := blaze.Window_calculate_scale(&(this.window),
		this.options.gui_scale.val,
		Minecraft_is_enforce_unicode(this))

	blaze.Window_set_gui_scale(&(this.window), cast(f64) i)
	if this.screen != nil {
		Screen_resize(&(this.screen.?), this,
			this.window.gui_scaled_width,
			this.window.gui_scaled_height)
	}
}

// @SubintProc
Minecraft_cursor_entered :: proc(this: ^Minecraft)
{

}

Minecraft_SUBINT_WindowEventHandler :: proc() -> (out: blaze.WindowEventHandler)
{
	out = {
		set_window_active		= cast(type_of(out.set_window_active)) Minecraft_set_window_active,
		resize_display			= cast(type_of(out.resize_display)) Minecraft_resize_display,
		cursor_entered			= cast(type_of(out.cursor_entered)) Minecraft_cursor_entered,
	}
	return
}

Minecraft_init :: proc(this: ^Minecraft, gc: ^GameConfig)
{
	when conf.DEBUG == conf.YES { fmt.println("MC INIT") }
	// Default values (not part of Java code)
	this.pending_reload = false
	ContinuousProfiler_init(&(this.fps_pie_profiler),
		mc_common.Util_time_source,
		{ get = proc(this: rawptr) -> (int)
		{
			return cast(int) ((^Minecraft)(this)).fps_pie_render_ticks
		}})

	this.right_click_delay = 0

	// TODO: super("Client")
	Minecraft_INST = this
	this.game_dir = gc.location.game_dir
	asset_dir := gc.location.asset_dir

	// ...
	this.running = true

	// ...
	disp_d := blaze.DisplayData{}
	if this.options.override_height > 0 && this.options.override_width > 0 {
		disp_d = {
			this.options.override_width, this.options.override_height,
			gc.display.fs_width, gc.display.fs_height,
			gc.display.is_fullscreen,
		}
		fmt.println("Setting disp_d to override options values:", disp_d)
	} else {
		fmt.println("Setting disp_d to GameConfig.display:", gc.display)
		disp_d = gc.display
	}

	mc_common.Util_time_source = blaze.RenderSystem_init_backend_system()

	// NOTE: Replaced all the VirtualScreen stuff with this
	mc_as_handler := Minecraft_SUBINT_WindowEventHandler()
	blaze.ScreenManager_init(&(this.smgr)) // !!! SEGFAULT
	blaze.Window_init(&(this.window),
		&mc_as_handler,
		&(this.smgr),
		&disp_d,
		this.options.fullscreen_video_mode_string,
		Minecraft_create_title(this))
	this.window_active = true

	/*try {
		if (ON_OSX) {
			InputStream inputstream = this.getClientPackSource().getVanillaPack().getResource(PackType.CLIENT_RESOURCES, new ResourceLocation("icons/minecraft.icns"));
			MacosUtil.loadIcon(inputstream);
		} else {
			InputStream inputstream2 = this.getClientPackSource().getVanillaPack().getResource(PackType.CLIENT_RESOURCES, new ResourceLocation("icons/icon_16x16.png"));
			InputStream inputstream1 = this.getClientPackSource().getVanillaPack().getResource(PackType.CLIENT_RESOURCES, new ResourceLocation("icons/icon_32x32.png"));
			this.window.setIcon(inputstream2, inputstream1);
		}
	} catch (IOException ioexception) {
		LOGGER.error("Couldn't set icon", (Throwable)ioexception);
	}*/

	// this.window.setFramerateLimit(this.options.framerateLimit().get());
	blaze.Window_set_framerate_limit(&this.window, this.options.framerate_limit.val)

	// this.mouseHandler = new MouseHandler(this);
	MouseHandler_init(&this.mouse_handler, this)

	// this.mouseHandler.setup(this.window.getWindow());
	MouseHandler_setup(&this.mouse_handler, this.window.glfw_win_hnd)

// this.keyboardHandler = new KeyboardHandler(this);
// this.keyboardHandler.setup(this.window.getWindow());

	// RenderSystem.initRenderer(this.options.glDebugVerbosity, false);
	blaze.RenderSystem_init_renderer(this.options.gl_debug_verbosity, false)

	// this.mainRenderTarget = new MainTarget(this.window.getWidth(), this.window.getHeight());
	blaze.MainTarget_init(transmute(^blaze.MainTarget) &this.main_render_target, this.window.width, this.window.height)

	// this.mainRenderTarget.setClearColor(0.0F, 0.0F, 0.0F, 0.0F);
	blaze.RenderTarget_set_clear_color(&this.main_render_target, 0.0, 0.0, 0.0, 0.0)

	// this.mainRenderTarget.clear(ON_OSX);
	blaze.RenderTarget_clear(&this.main_render_target, ODIN_OS == .Darwin)

// this.resourceManager = new ReloadableResourceManager(PackType.CLIENT_RESOURCES);
// this.resourcePackRepository.reload();
// this.options.loadSelectedResourcePacks(this.resourcePackRepository);
// this.languageManager = new LanguageManager(this.options.languageCode);
// this.resourceManager.registerReloadListener(this.languageManager);
// this.textureManager = new TextureManager(this.resourceManager);
// this.resourceManager.registerReloadListener(this.textureManager);
// this.skinManager = new SkinManager(this.textureManager, new File(file1, "skins"), this.minecraftSessionService);
// this.levelSource = new LevelStorageSource(this.gameDirectory.toPath().resolve("saves"), this.gameDirectory.toPath().resolve("backups"), this.fixerUpper);
// this.soundManager = new SoundManager(this.resourceManager, this.options);
// this.resourceManager.registerReloadListener(this.soundManager);
// this.splashManager = new SplashManager(this.user);
// this.resourceManager.registerReloadListener(this.splashManager);
// this.musicManager = new MusicManager(this);
// this.fontManager = new FontManager(this.textureManager);
// this.font = this.fontManager.createFont();
// this.resourceManager.registerReloadListener(this.fontManager.getReloadListener());
// this.selectMainFont(this.isEnforceUnicode());
// this.resourceManager.registerReloadListener(new GrassColorReloadListener());
// this.resourceManager.registerReloadListener(new FoliageColorReloadListener());

	// this.window.setErrorSection("Startup");
	blaze.Window_set_error_section(&this.window, "Startup")

	// RenderSystem.setupDefaultState(0, 0, this.window.getWidth(), this.window.getHeight());
	blaze.RenderSystem_setup_default_state(0, 0, i32(this.window.width), i32(this.window.height))

	// this.window.setErrorSection("Post startup");
	blaze.Window_set_error_section(&this.window, "Post startup")

// this.blockColors = BlockColors.createDefault();
// this.itemColors = ItemColors.createDefault(this.blockColors);
// this.modelManager = new ModelManager(this.textureManager, this.blockColors, this.options.mipmapLevels().get());
// this.resourceManager.registerReloadListener(this.modelManager);
// this.entityModels = new EntityModelSet();
// this.resourceManager.registerReloadListener(this.entityModels);
// this.blockEntityRenderDispatcher = new BlockEntityRenderDispatcher(this.font, this.entityModels, this::getBlockRenderer, this::getItemRenderer, this::getEntityRenderDispatcher);
// this.resourceManager.registerReloadListener(this.blockEntityRenderDispatcher);
// BlockEntityWithoutLevelRenderer blockentitywithoutlevelrenderer = new BlockEntityWithoutLevelRenderer(this.blockEntityRenderDispatcher, this.entityModels);
// this.resourceManager.registerReloadListener(blockentitywithoutlevelrenderer);
// this.itemRenderer = new ItemRenderer(this.textureManager, this.modelManager, this.itemColors, blockentitywithoutlevelrenderer);
// this.resourceManager.registerReloadListener(this.itemRenderer);
// this.renderBuffers = new RenderBuffers();
// this.playerSocialManager = new PlayerSocialManager(this, this.userApiService);
// this.blockRenderer = new BlockRenderDispatcher(this.modelManager.getBlockModelShaper(), blockentitywithoutlevelrenderer, this.blockColors);
// this.resourceManager.registerReloadListener(this.blockRenderer);
// this.entityRenderDispatcher = new EntityRenderDispatcher(this, this.textureManager, this.itemRenderer, this.blockRenderer, this.font, this.options, this.entityModels);
// this.resourceManager.registerReloadListener(this.entityRenderDispatcher);
	// this.gameRenderer = new GameRenderer(this, this.entityRenderDispatcher.getItemInHandRenderer(), this.resourceManager, this.renderBuffers);
	GameRenderer_init(&this.game_renderer,
		this,
		EntityRenderDispatcher_get_item_in_hand_renderer(&this.entity_render_dispatcher),
		&this.resmgr,
		&this.render_buffers)

// this.resourceManager.registerReloadListener(this.gameRenderer);
// this.levelRenderer = new LevelRenderer(this, this.entityRenderDispatcher, this.blockEntityRenderDispatcher, this.renderBuffers);
// this.resourceManager.registerReloadListener(this.levelRenderer);
// this.createSearchTrees();
// this.resourceManager.registerReloadListener(this.searchRegistry);
// this.particleEngine = new ParticleEngine(this.level, this.textureManager);
// this.resourceManager.registerReloadListener(this.particleEngine);
// this.paintingTextures = new PaintingTextureManager(this.textureManager);
// this.resourceManager.registerReloadListener(this.paintingTextures);
// this.mobEffectTextures = new MobEffectTextureManager(this.textureManager);
// this.resourceManager.registerReloadListener(this.mobEffectTextures);
// this.gpuWarnlistManager = new GpuWarnlistManager();
// this.resourceManager.registerReloadListener(this.gpuWarnlistManager);
// this.resourceManager.registerReloadListener(this.regionalCompliancies);
// this.gui = new Gui(this, this.itemRenderer);
// this.debugRenderer = new DebugRenderer(this);
// RenderSystem.setErrorCallback(this::onFullscreenError);


	/*this.setOverlay(new LoadingOverlay(this, this.resourceManager.createReload(Util.backgroundExecutor(), this, RESOURCE_RELOAD_INITIAL_TASK, list), (p_210745_) -> {
         Util.ifElse(p_210745_, this::rollbackResourcePacks, () -> {
            if (SharedConstants.IS_RUNNING_IN_IDE) {
               this.selfTest();
            }

            this.reloadStateTracker.finishReload();
         });
	}, false));*/

	LoadingOverlay_init(&(this.overlay.?), this)

	return
}

Minecraft_get_instance :: #force_inline proc() -> (^Minecraft)
{
	return Minecraft_INST
}

Minecraft_get_single_player_server :: #force_inline proc(this: ^Minecraft) -> (^IntegratedServer)
{
	return &(this.single_player_server.?)
}

Minecraft_get_camera_entity :: #force_inline proc(this: ^Minecraft) -> (^Entity)
{
	return &(this.camera_ent.?)
}

// @FullyImplemented
// @VerifiedParity
Minecraft_render_on_thread :: proc(this: ^Minecraft) -> (bool)
{
	return false
}

Minecraft_run :: proc(this: ^Minecraft)
{
	when conf.DEBUG == conf.YES { fmt.println("MC RUN") }
	// IMPL
	this.game_thread = j_lang.Thread_current_thread()

	/*if (Runtime.getRuntime().availableProcessors() > 4) {
    	this.gameThread.setPriority(10);
	}*/

	{
		global.push_exception_frame()
		defer { global.check(); global.pop_exception_frame() }

		flag := false

		for this.running {
			if this.delayed_crash.get != nil { // If proc ptr has been set from nil state
				Minecraft_crash(this, this.delayed_crash.get((rawptr)(this)))
				return
			}

			{
				global.push_exception_frame()
				defer { global.check(); global.pop_exception_frame() }

				/*SingleTickProfiler singletickprofiler = SingleTickProfiler.createTickProfiler("Renderer");
				boolean flag1 = this.shouldRenderFpsPie();
				this.profiler = this.constructProfiler(flag1, singletickprofiler);
				this.profiler.startTick();
				this.metricsRecorder.startTick();*/

				flag := Minecraft_should_render_fps_pie(this)

				/*this.profiler = this.constructProfiler(flag1, singletickprofiler);
				this.profiler.startTick();
				this.metricsRecorder.startTick();*/

				// when conf.DEBUG == conf.YES { fmt.println("BEFORE Minecraft_run_tick()") }
				Minecraft_run_tick(this, !flag)
				// when conf.DEBUG == conf.YES { fmt.println("AFTER Minecraft_run_tick()") }

				/*this.profiler.endTick();
				this.finishProfilers(flag1, singletickprofiler);*/

				if global.catch({ .OutOfMemoryError }) {
					if flag {
						global.throw({ .OutOfMemoryError }, /*fmt.aprintf*/("Out of memory!"))
					}

					Minecraft_emergency_save(this)

					oom_s: Screen
					OutOfMemoryScreen_init((^OutOfMemoryScreen)(&oom_s))
					Minecraft_set_screen(this, oom_s)

					// System.gc()
					// LOGGER.error(LogUtils.FATAL_MARKER, "Out of memory", (Throwable)outofmemoryerror);
					flag = true
				}
			}
		}


	}
}

Minecraft_run_tick :: proc(this: ^Minecraft, flag: bool)
{
	blaze.Window_set_error_section(&this.window, "Pre render")
	nanos := j_util.Date_new_from_current_time()
	if blaze.Window_should_close(&this.window)
	{
		Minecraft_stop(this) // IMPL
	}

	_, is_loading_overlay := this.overlay.?
	if this.pending_reload != false && !(is_loading_overlay)
	{
		this.pending_reload = false
		Minecraft_reload_resource_packs(this, false)
	}

	for runnable in &(this.progress_tasks)
	{
		runnable->run()
	}

	if flag
	{
		j := Timer_advance_time(&(this.timer), mc_common.Util_get_millis.get(nil))
        BlockableEventLoop_run_all_tasks(&(this.rb_evtloop.bl_evtloop))

        for k := 0; k < min(10, j); k += 1
        {
			Minecraft_tick(this)
        }
	}

// this.mouseHandler.turnPlayer();
	MouseHandler_turn_player(&this.mouse_handler)

//      this.window.setErrorSection("Render");
//      this.profiler.push("sound");
//      this.soundManager.updateSource(this.gameRenderer.getMainCamera());
//      this.profiler.pop();
//      this.profiler.push("render");
	//      boolean flag1;
 	flag1: bool

//      if (!this.options.renderDebug && !this.metricsRecorder.isRecording()) {
//         flag1 = false;
//         this.gpuUtilization = 0.0D;
//      } else {
//         flag1 = this.currentFrameProfile == null || this.currentFrameProfile.isDone();
//         if (flag1) {
//            TimerQuery.getInstance().ifPresent(TimerQuery::beginProfile);
//         }
//      }

	//      PoseStack posestack = RenderSystem.getModelViewStack();
	p_stack := blaze.RenderSystem_get_model_view_stack()

	//      posestack.pushPose();
	blaze.PoseStack_push_pose(p_stack)

	//      RenderSystem.applyModelViewMatrix();
	blaze.RenderSystem_apply_model_view_matrix()

	//      RenderSystem.clear(16640, ON_OSX);
	blaze.RenderSystem_clear(16640, (ODIN_OS == .Darwin))

	//      this.mainRenderTarget.bindWrite(true);
	blaze.RenderTarget_bind_write(&this.main_render_target, true)

//      FogRenderer.setupNoFog();
//      this.profiler.push("display");
//      RenderSystem.enableTexture();
//      RenderSystem.enableCull();
//      this.profiler.pop();


//      if (!this.noRender) {
//         this.profiler.popPush("gameRenderer");
//         this.gameRenderer.render(this.pause ? this.pausePartialTick : this.timer.partialTick, i, p_91384_);
//         this.profiler.popPush("toasts");
//         this.toast.render(new PoseStack());
//         this.profiler.pop();
//      }
	if !this.no_render
	{
		GameRenderer_render(&this.game_renderer, this.pause_partial_tick if this.pause else this.timer.partial_tick, nanos, flag)
	}

//      if (this.fpsPieResults != null) {
//         this.profiler.push("fpsPie");
//         this.renderFpsMeter(new PoseStack(), this.fpsPieResults);
//         this.profiler.pop();
//      }

//      this.profiler.push("blit");
//      this.mainRenderTarget.unbindWrite();
//      posestack.popPose();
//      posestack.pushPose();
//      RenderSystem.applyModelViewMatrix();
//      this.mainRenderTarget.blitToScreen(this.window.getWidth(), this.window.getHeight());
//      if (flag1) {
//         TimerQuery.getInstance().ifPresent((p_231363_) -> {
//            this.currentFrameProfile = p_231363_.endProfile();
//         });
//      }

//      posestack.popPose();
//      RenderSystem.applyModelViewMatrix();
//      this.profiler.popPush("updateDisplay");
	//      this.window.updateDisplay();
 	blaze.Window_update_display(&this.window)
//      int l = this.getFramerateLimit();
//      if (l < 260) {
//         RenderSystem.limitDisplayFPS(l);
//      }

//      this.profiler.popPush("yield");
//      Thread.yield();
//      this.profiler.pop();
//      this.window.setErrorSection("Post render");
	//      ++this.frames;
	this.frames += 1
//      boolean flag = this.hasSingleplayerServer() && (this.screen != null && this.screen.isPauseScreen() || this.overlay != null && this.overlay.isPauseScreen()) && !this.singleplayerServer.isPublished();
//      if (this.pause != flag) {
//         if (this.pause) {
//            this.pausePartialTick = this.timer.partialTick;
//         } else {
//            this.timer.partialTick = this.pausePartialTick;
//         }

//         this.pause = flag;
//      }

//      long i1 = Util.getNanos();
//      long j1 = i1 - this.lastNanoTime;
//      if (flag1) {
//         this.savedCpuDuration = j1;
//      }

//      this.frameTimer.logFrameDuration(j1);
//      this.lastNanoTime = i1;
//      this.profiler.push("fpsUpdate");
//      if (this.currentFrameProfile != null && this.currentFrameProfile.isDone()) {
//         this.gpuUtilization = (double)this.currentFrameProfile.get() * 100.0D / (double)this.savedCpuDuration;
//      }

//      while(Util.getMillis() >= this.lastTime + 1000L) {
//         String s;
//         if (this.gpuUtilization > 0.0D) {
//            s = " GPU: " + (this.gpuUtilization > 100.0D ? ChatFormatting.RED + "100%" : Math.round(this.gpuUtilization) + "%");
//         } else {
//            s = "";
//         }

//         fps = this.frames;
//         this.fpsString = String.format("%d fps T: %s%s%s%s B: %d%s", fps, l == 260 ? "inf" : l, this.options.enableVsync().get() ? " vsync" : "", this.options.graphicsMode().get(), this.options.cloudStatus().get() == CloudStatus.OFF ? "" : (this.options.cloudStatus().get() == CloudStatus.FAST ? " fast-clouds" : " fancy-clouds"), this.options.biomeBlendRadius().get(), s);
//         this.lastTime += 1000L;
//         this.frames = 0;
//      }

//      this.profiler.pop();
}

Minecraft_tick :: proc(this: ^Minecraft)
{
	if this.right_click_delay > 0 {
		this.right_click_delay -= 1
	}

	Profiler_push(&(this.profiler), "gui")
	Gui_tick(&(this.gui), this.pause)
}

Minecraft_construct_profiler :: proc(this: ^Minecraft, flag: bool, stp: ^SingleTickProfiler) -> (^Profiler)
{
	if !flag {

	}

	out := new(Profiler)
	return out
}

// IMPL
Minecraft_should_report_as_modified :: proc(this: ^Minecraft) -> (bool)
{
	return false
}

// IMPL
// @Static
Minecraft_check_mod_status :: proc() -> (ModCheck)
{
	return { .ProbablyNot, "" }
}

Minecraft_select_main_font :: proc(this: ^Minecraft, flag: bool)
{
	floc_map := make(FontLocationMap)
	floc_map[Minecraft_DEFAULT_FONT] = Minecraft_UNIFORM_FONT

	FontManager_set_renames(&(this.font_mgr), floc_map)
}

Minecraft_create_title :: proc(this: ^Minecraft) -> (string)
{
	sb := strings.builder_make()
	strings.write_string(&sb, "Minecraft")

	is_modded := Minecraft_check_mod_status().confidence != .ProbablyNot
	if is_modded {
		strings.write_string(&sb, "*")
	}

	strings.write_string(&sb, " ")
	strings.write_string(&sb, (get_current_version()).name)

	// cpl := Minecraft_get_connection(this)

	return "" // IMPL
}

Minecraft_get_connection :: proc(this: ^Minecraft) -> (^ClientPacketListener)
{
	unbox_player := &(this.player.?)
	return (^ClientPacketListener)(nil) if (this.player == nil) else &(unbox_player.connection)
}

/*Minecraft_poll_task :: proc(this: ^Minecraft) -> (bool)
{

}

Minecraft_run_all_tasks :: proc(this: ^Minecraft)
{
	for Minecraft_poll_task(this) {}
}*/

Minecraft_reload_resource_packs :: proc(this: ^Minecraft, flag: bool)
{
	if this.pending_reload != false {
		return
	}

	/*CompletableFuture<Void> completablefuture = new CompletableFuture<>();
	if (!p_168020_ && this.overlay instanceof LoadingOverlay) {
		this.pendingReload = completablefuture;
		return completablefuture;
	} else {
		this.resourcePackRepository.reload();
		List<PackResources> list = this.resourcePackRepository.openAllSelected();
		if (!p_168020_) {
		   this.reloadStateTracker.startReload(ResourceLoadStateTracker.ReloadReason.MANUAL, list);
		}

		this.setOverlay(new LoadingOverlay(this, this.resourceManager.createReload(Util.backgroundExecutor(), this, RESOURCE_RELOAD_INITIAL_TASK, list), (p_231394_) -> {
		   Util.ifElse(p_231394_, this::rollbackResourcePacks, () -> {
		      this.levelRenderer.allChanged();
		      this.reloadStateTracker.finishReload();
		      completablefuture.complete((Void)null);
		   });
		}, true));
		return completablefuture;
	}*/


}

Minecraft_get_delta_frame_time :: proc(this: ^Minecraft) -> (f32)
{
	return this.timer.tick_delta
}

Minecraft_set_screen :: proc(this: ^Minecraft, screen: Screen)
{
	if this.screen != nil {

	}
}

Minecraft_emergency_save :: proc(this: ^Minecraft)
{

}

Minecraft_crash :: proc(this: ^Minecraft, cr: ^CrashReport)
{

}

Minecraft_stop :: proc(this: ^Minecraft)
{
	// IMPL
}

// IMPL
Minecraft_destroy :: proc(this: ^Minecraft)
{
	/*{
		// outer try-catch
		global.push_exception_frame()
		defer { global.check(); global.pop_exception_frame() }

		logging.log(.Info, "Stopping!")
		{
			global.push_exception_frame()
			defer { global.check() }

			// IMPL: NarratorChatListener_destroy(&g_NarratorChatListener)
			if global.catch({ .Throwable }) {}
		}

		{
			global.push_exception_frame()
			defer { global.check(); global.pop_exception_frame() }

			if this.level != nil {
				ClientLevel_disconnect(this.level)
			}

			Minecraft_clear_level()

			if global.catch({ .Throwable }) {}
		}

		if this.screen != nil {
			// this.screen.removed()
		}

		Minecraft_close(this)

		// finally {
		Util_time_source = j_lang.System_nano_time
		if this.delayed_crash == nil {
			j_lang.System_exit(0)
		}
		// }
	}*/
}

Minecraft_is_64bit :: proc(this: ^Minecraft) -> (bool)
{
	#assert(size_of(int) == size_of(rawptr))
	#assert(size_of(rawptr) == 4 || size_of(rawptr) == 8)

	return size_of(rawptr) == 8 // true only on 64bit
}

Minecraft_should_render_fps_pie :: proc(this: ^Minecraft) -> (bool)
{
	return (this.options.render_debug && this.options.render_debug_charts && !this.options.hide_gui)
}

Minecraft_is_running :: proc(this: ^Minecraft) -> (bool)
{
	// IMPL
	return true
}

Minecraft_is_enforce_unicode :: proc(this: ^Minecraft) -> (bool)
{
	return this.options.force_unicode_font.val
}