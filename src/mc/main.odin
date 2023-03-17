package mc
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import odin_thread "core:thread"

import global			"mco:odin/global"
import conf				"mco:odin/conf"

import blaze			"mco:extern/com_mojang/blaze3d"

import					"mco:extern/com_mojang/logging"
import jopt				"mco:extern/net_sf/jopt_simple"

import j_lang			"mco:java/lang"
import j_io				"mco:java/io"
import j_net			"mco:java/net"
import j_util			"mco:java/util"

import JGL				"mco:extern/org_lwjgl/lwjgl/opengl"

import mc_common "mco:mc/common"

@(private="file")
glog := &logging.g_logger

ARG_GAME_DIR :: "gameDir"
ARG_ASSETS_DIR :: "assetsDir"
ARG_RESOURCE_PACK_DIR :: "resourcePackDir"
ARG_PROXY_HOST :: "proxyHost"
ARG_PROXY_PORT :: "proxyPort"
ARG_PROXY_USER :: "proxyUser"
ARG_PROXY_PASS :: "proxyPass"
ARG_DEMO :: "demo"
ARG_DISABLE_MULTI :: "disableMultiplayer"
ARG_DISABLE_CHAT :: "disableChat"
ARG_FULLSCREEN :: "fullscreen"
ARG_WIDTH :: "width"
ARG_HEIGHT :: "height"
ARG_FWIDTH :: "fullscreenWidth"
ARG_FHEIGHT :: "fullscreenHeight"
ARG_VERSION :: "version"
ARG_USERNAME :: "username"
ARG_UUID :: "uuid"
ARG_XUID :: "xuid"
ARG_CLIENT_ID :: "clientId"
ARG_ACCESS_TOKEN :: "accessToken"
ARG_USER_TYPE :: "userType"
ARG_VERSION_TYPE :: "versionType"
ARG_ASSET_INDEX :: "assetIndex"
ARG_SERVER :: "server"
ARG_PORT :: "port"
ARG_CHECK_GL_ERRORS :: "checkGlErrors"
ARG_JFR_PROF :: "jfrProfile"
ARG_USER_PROPS :: "userProperties"
ARG_PROF_PROPS :: "profileProperties"

mc_inst: ^Minecraft = nil
main :: proc()
{
	// ODIN-SPECIFIC SETUP
	// Some things must be setup at runtime before the main MC code actually starts
	// This section DOES NOT MAP to the original Java source in any way
	// It is simply for setting up static values like in static{} blocks and
	// static class fields.
	// ****************************************************************
	// ***                      HOUSEKEEPING                        ***
	// ****************************************************************

	global.init_memory(conf.TALLOC_SIZE) // uses odin default context initially
	// context = global.custom_context // now switches to custom ctx for rest of program execution

	// INIT CORE
	j_lang.INIT()
	// j_regex.INIT()

	// INIT PLATFORM
	JGL.INIT()
	blaze.INIT()

	// INIT DEBUG
	Profiling_INIT()

	// INIT WORLD
	// GameType_INIT()
	Items_INIT()

	// INIT NET
	Components_INIT()
	Style_INIT()

	// INIT MAIN
	MCVersion_INIT()

	// INIT MISC
	Options_INIT()
	ItemRenderer_INIT()
	Screens_INIT()

	Minecraft_INIT()


	// ****************************************************************
	// ***                      MCO BEGIN                           ***
	// ****************************************************************

	try_detect_version()
	// SharedConstants.enableDataFixerOptimizations(); // Commented out because whatever "data fixer" is, we probably don't need it at all here.

	// Setup options parser
	op: jopt.OptionParser
	op.allows_unrecognized_options = true

	jopt.OptionParser_accepts(&op, ARG_DEMO,					.Unspecified, .Unspecified, "")
	jopt.OptionParser_accepts(&op, ARG_DISABLE_MULTI,			.Unspecified, .Unspecified, "")
	jopt.OptionParser_accepts(&op, ARG_DISABLE_CHAT,			.Unspecified, .Unspecified, "")
	jopt.OptionParser_accepts(&op, ARG_FULLSCREEN,				.Unspecified, .Unspecified, "")
	jopt.OptionParser_accepts(&op, ARG_CHECK_GL_ERRORS,			.Unspecified, .Unspecified, "")
	jopt.OptionParser_accepts(&op, ARG_JFR_PROF,				.Unspecified, .Unspecified, "")

	jopt.OptionParser_accepts(&op, ARG_SERVER, 					.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_PORT, 					.Unspecified, .Required, "25565")
	jopt.OptionParser_accepts(&op, ARG_GAME_DIR, 				.Unspecified, .Required, global.resolve("."))
	jopt.OptionParser_accepts(&op, ARG_ASSETS_DIR, 				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_RESOURCE_PACK_DIR,		.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_PROXY_HOST, 				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_PROXY_PORT, 				.Unspecified, .Required, "8080")
	jopt.OptionParser_accepts(&op, ARG_PROXY_USER, 				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_PROXY_PASS, 				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_USERNAME,				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_UUID, 					.Unspecified, .Required, "")

	jopt.OptionParser_accepts(&op, ARG_XUID, 					.Unspecified, .Optional, "")
	jopt.OptionParser_accepts(&op, ARG_CLIENT_ID,				.Unspecified, .Optional, "")

	jopt.OptionParser_accepts(&op, ARG_ACCESS_TOKEN,			.Required, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_VERSION,					.Required, .Required, "")

	jopt.OptionParser_accepts(&op, ARG_WIDTH,					.Unspecified, .Required, "-1")
	jopt.OptionParser_accepts(&op, ARG_HEIGHT,					.Unspecified, .Required, "-1")
	jopt.OptionParser_accepts(&op, ARG_FWIDTH,					.Unspecified, .Required, "-1")
	jopt.OptionParser_accepts(&op, ARG_FHEIGHT,					.Unspecified, .Required, "-1")
	jopt.OptionParser_accepts(&op, ARG_USER_PROPS,				.Unspecified, .Required, "{}")
	jopt.OptionParser_accepts(&op, ARG_PROF_PROPS,				.Unspecified, .Required, "{}")
	jopt.OptionParser_accepts(&op, ARG_ASSET_INDEX,				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_USER_TYPE,				.Unspecified, .Required, "")
	jopt.OptionParser_accepts(&op, ARG_VERSION_TYPE,			.Unspecified, .Required, "release")

	jopt.OptionParser_parse(&op, os.args[1:])

	unhandled := jopt.OptionParser_non_options(&op)
	if len(unhandled) > 0 {
		fmt.println("Completely ignored arguments: ", unhandled)
	}

	// Grab proxy host
	proxy_host := jopt.OptionParser_get(&op, ARG_PROXY_HOST, string)
	proxy_port := jopt.OptionParser_get(&op, ARG_PROXY_PORT, int)
	proxy: j_net.Proxy = j_net.NO_PROXY

	// Attempt to create a new proxy from the CLI args
	if string_has_value(proxy_host) {
		inet_sock_addr: j_net.InetSocketAddress
		j_net.InetSocketAddress_init(&inet_sock_addr, proxy_host, proxy_port)
		j_net.Proxy_init(&proxy, j_net.ProxyType.Socks, inet_sock_addr)
	}

	p_usr := jopt.OptionParser_get(&op, ARG_PROXY_USER, string)
	p_pass := jopt.OptionParser_get(&op, ARG_PROXY_PASS, string)
	if !j_net.Proxy_equals(&proxy, &j_net.NO_PROXY) && string_has_value(p_usr) && string_has_value(p_pass) {
		// TODO: implement authenticator code
	}

	// Grab width/height
	w := jopt.OptionParser_get(&op, ARG_WIDTH, int)
	h := jopt.OptionParser_get(&op, ARG_HEIGHT, int)
	fw := jopt.OptionParser_get(&op, ARG_FWIDTH, int)
	fh := jopt.OptionParser_get(&op, ARG_FHEIGHT, int)
	fmt.println(w, h, fw, fh)

	has_full := jopt.OptionParser_has(&op, ARG_FULLSCREEN)
	has_demo := jopt.OptionParser_has(&op, ARG_DEMO)
	has_disable_multi := jopt.OptionParser_has(&op, ARG_DISABLE_MULTI)
	has_disable_chat := jopt.OptionParser_has(&op, ARG_DISABLE_CHAT)

	// Grab version
	ver := jopt.OptionParser_get(&op, ARG_VERSION, string)

	// TODO: Implement GSON stuff to parse the 2 JSON-based arguments

	/* AND ALL THIS
	String s4 = parseArgument(optionset, optionspec24);
	File file1 = parseArgument(optionset, optionspec3);
	File file2 = optionset.has(optionspec4) ? parseArgument(optionset, optionspec4) : new File(file1, "assets/");
	File file3 = optionset.has(optionspec5) ? parseArgument(optionset, optionspec5) : new File(file1, "resourcepacks/");
	String s5 = optionset.has(optionspec11) ? optionspec11.value(optionset) : UUIDUtil.createOfflinePlayerUUID(optionspec10.value(optionset)).toString();
	String s6 = optionset.has(optionspec22) ? optionspec22.value(optionset) : null;
	String s7 = optionset.valueOf(optionspec12);
	String s8 = optionset.valueOf(optionspec13);
	String s9 = parseArgument(optionset, optionspec1);
	Integer integer = parseArgument(optionset, optionspec2);
	if (optionset.has(optionspec)) {
	JvmProfiler.INSTANCE.start(Environment.CLIENT);
	}

	CrashReport.preload();
	Bootstrap.bootStrap();
	Bootstrap.validate();
	Util.startTimerHackThread();
	String s10 = optionspec23.value(optionset);
	User.Type user$type = User.Type.byName(s10);
	if (user$type == null) {
	LOGGER.warn("Unrecognized user type: {}", (Object)s10);
	 }
	*/

	// Read in some dirs
	game_dir_s := jopt.OptionParser_get(&op, ARG_GAME_DIR, string)
	asset_dir_arg := jopt.OptionParser_get(&op, ARG_ASSETS_DIR, string)
	asset_dir_s := global.join({ game_dir_s, asset_dir_arg })
	res_dir_arg := jopt.OptionParser_get(&op, ARG_RESOURCE_PACK_DIR, string)
	res_dir_s := global.join({ game_dir_s, res_dir_arg })

	game_dir_f: j_io.File; j_io.File_open(&game_dir_f, game_dir_s)
	asset_dir_f: j_io.File; j_io.File_open(&asset_dir_f, asset_dir_s)
	res_dir_f: j_io.File; j_io.File_open(&res_dir_f, res_dir_s)

	asset_index_str := jopt.OptionParser_get(&op, ARG_ASSET_INDEX, string)

	// Grab some more meta data
	version_type := jopt.OptionParser_get(&op, ARG_VERSION_TYPE, string)
	uname := jopt.OptionParser_get(&op, ARG_USERNAME, string)
	client_id := jopt.OptionParser_get(&op, ARG_CLIENT_ID, string)
	xuid := jopt.OptionParser_get(&op, ARG_XUID, string)

	utype: UserType = .Msa

	uuid: string
	if jopt.OptionParser_has(&op, ARG_UUID) {
		uuid = jopt.OptionParser_get(&op, ARG_UUID, string)
	} else {
		raw_uuid := UUIDUtil_create_offline_player_uuid(uname)
		uuid = j_util.UUID_to_string(&raw_uuid)
	}

	// Anyway, time to make the actual User
	tok := jopt.OptionParser_get(&op, ARG_ACCESS_TOKEN, string)
	user := User_new(uname, uuid, tok, xuid, client_id, utype)

	server := jopt.OptionParser_get(&op, ARG_SERVER, string)
	port := jopt.OptionParser_get(&op, ARG_PORT, int)

	// Make a GameConfig
	gconf := GameConfig{
		user = UserData{ user, nil, nil, proxy },
		display = blaze.DisplayData{ w, h, fw, fh, has_full },
		location = FolderData{ game_dir_f, res_dir_f, asset_dir_f, asset_index_str },
		game = GameData{ has_demo, ver, version_type, has_disable_multi, has_disable_chat },
		server = ServerData{ server, port },
	}

	// Since java's Runtime cannot be emulated here, we instead simply set a thread to run whenever a
	// "thread panic" happens. A thread panic should be triggered whenever the program should exit
	// immediately due to some error. So, even if the program is exiting due to an exception-related
	// error, the code in exceptions.odin will still call into Thread_panic() instead of default panic()
	// to exit
	client_shutdown_thread := j_lang.Thread_new("Client Shutdown Thread", shutdown_proc, .Normal)
	j_lang.Thread_set_panic_thread(client_shutdown_thread)
	shutdown_proc :: proc(t: ^j_lang.OdinThread)
	{
		j_thread := j_lang.Thread_get_argument(t, ^j_lang.Thread)
		mc_inst := Minecraft_get_instance()
		if mc_inst != nil {
			iserver := Minecraft_get_single_player_server(mc_inst)
			if iserver != nil {
				IntegratedServer_halt(iserver, true)
			}
		}
	}

	{
		global.push_exception_frame() // begin local exception frame
		defer global.pop_exception_frame()

		cthread := j_lang.Thread_current_thread()
		j_lang.Thread_set_name(cthread, "Render thread")
		// j_lang.Thread_print()

		blaze.RenderSystem_init_render_thread()
		blaze.RenderSystem_begin_initialization()

		mc_inst = new(Minecraft)
		Minecraft_init(mc_inst, &gconf)

		blaze.RenderSystem_finish_initialization()

		// Catch exceptions
		if global.catch({ .SilentInitException }) {
			logging.log(.Warn, "Failed to create window: ", global.last_caught())
			return
		} else if global.catch({ .Exception }) {
			// IMPL
			// Create crash report
			// Minecraft.fillReport
			// Minecraft.crash
		}

		global.check() // panics if uncaught exceptions on local frame
	}

	game_thread: ^j_lang.Thread
	if Minecraft_render_on_thread((mc_inst)) {
		game_thread = j_lang.Thread_new("Game thread", game_run, .Normal)
		game_run :: proc(t: ^j_lang.OdinThread)
		{
			global.push_exception_frame()
			defer global.pop_exception_frame()

			blaze.RenderSystem_init_game_thread(true)
			Minecraft_run((mc_inst))

			if global.catch({ .Exception }) {
				logging.log(.Error, "Exception in client thread", global.last_caught())
			}

			global.check()
		}

		j_lang.Thread_start(game_thread)
		for Minecraft_is_running((mc_inst)) {}
	} else {
		game_thread = nil

		global.push_exception_frame()
		defer global.pop_exception_frame()

		blaze.RenderSystem_init_game_thread(false)
		Minecraft_run((mc_inst))

		if global.catch({ .Exception }) {
			logging.log(.Error, "Unhandled game exception", global.last_caught())
		}

		global.check()
	}

	blaze.BufferUploader_reset()

	{
		global.push_exception_frame()
		defer global.pop_exception_frame()

		Minecraft_stop((mc_inst))
		if game_thread != nil {
			j_lang.Thread_join(game_thread)
		}

		if global.catch({ .InterruptedException }) {
			logging.log(.Error, "Exception during client thread shutdown", global.last_caught())
		}

		// finally {
		Minecraft_destroy((mc_inst))
		// }
		global.check()
	}
}

string_has_value :: #force_inline proc(str: string) -> (bool)
{
	return len(str) > 0
}