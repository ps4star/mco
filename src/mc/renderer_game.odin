package mc
import "core:time"
import "core:fmt"
import "core:strings"
import "core:slice"

import blaze "mco:extern/com_mojang/blaze3d"
import cm_math "mco:extern/com_mojang/math"

import mc_common "mco:mc/common"

Time :: time.Time

@(private="package") position_shader: ^mc_common.ShaderInstance
@(private="package") position_color_shader: ^mc_common.ShaderInstance
@(private="package") position_color_tex_shader: ^mc_common.ShaderInstance
@(private="package") position_tex_shader: ^mc_common.ShaderInstance
@(private="package") position_tex_color_shader: ^mc_common.ShaderInstance
@(private="package") block_shader: ^mc_common.ShaderInstance
@(private="package") new_entity_shader: ^mc_common.ShaderInstance
@(private="package") particle_shader: ^mc_common.ShaderInstance
@(private="package") position_color_lightmap_shader: ^mc_common.ShaderInstance

GameRenderer :: struct
{
	minecraft: ^Minecraft,

	resmgr: ^ResourceManager,
	iihr: ^ItemInHandRenderer,
	map_renderer: MapRenderer,
	light_texture: LightTexture,
	rbufs: ^RenderBuffers,

	post_effect: Maybe(PostChain),
}

GameRenderer_init :: proc(this: ^GameRenderer,
	minecraft: ^Minecraft,
	iihr: ^ItemInHandRenderer,
	resmgr: ^ResourceManager,
	rbufs: ^RenderBuffers)
{
	this.minecraft = minecraft
	this.resmgr = resmgr
	this.iihr = iihr
	MapRenderer_init(&this.map_renderer, &minecraft.tex_mgr)
	LightTexture_init(&this.light_texture, this, minecraft)
	this.rbufs = rbufs
	this.post_effect = nil
}

GameRenderer_pick :: proc(this: ^GameRenderer, f: f32)
{
	cam_ent := Minecraft_get_camera_entity(this.minecraft)
	if cam_ent != nil {
		if this.minecraft.level != nil {
			// push "pick" to mc profiler
			this.minecraft.crosshair_pick_entity = nil
			d0 := cast(f64) MultiPlayerGameMode_get_pick_range(&(this.minecraft.game_mode.?))
			// this.minecraft.hitResult = entity.pick(d0, p_109088_, false);
   //          Vec3 vec3 = entity.getEyePosition(p_109088_);
   //          boolean flag = false;
   //          int i = 3;
   //          double d1 = d0;
   //          if (this.minecraft.gameMode.hasFarPickRange()) {
   //             d1 = 6.0D;
   //             d0 = d1;
   //          } else {
   //             if (d0 > 3.0D) {
   //                flag = true;
   //             }

   //             d0 = d0;
   //          }

   //          d1 *= d1;
   //          if (this.minecraft.hitResult != null) {
   //             d1 = this.minecraft.hitResult.getLocation().distanceToSqr(vec3);
   //          }

   //          Vec3 vec31 = entity.getViewVector(1.0F);
   //          Vec3 vec32 = vec3.add(vec31.x * d0, vec31.y * d0, vec31.z * d0);
   //          float f = 1.0F;
   //          AABB aabb = entity.getBoundingBox().expandTowards(vec31.scale(d0)).inflate(1.0D, 1.0D, 1.0D);
   //          EntityHitResult entityhitresult = ProjectileUtil.getEntityHitResult(entity, vec3, vec32, aabb, (p_234237_) -> {
   //             return !p_234237_.isSpectator() && p_234237_.isPickable();
   //          }, d1);
   //          if (entityhitresult != null) {
   //             Entity entity1 = entityhitresult.getEntity();
   //             Vec3 vec33 = entityhitresult.getLocation();
   //             double d2 = vec3.distanceToSqr(vec33);
   //             if (flag && d2 > 9.0D) {
   //                this.minecraft.hitResult = BlockHitResult.miss(vec33, Direction.getNearest(vec31.x, vec31.y, vec31.z), new BlockPos(vec33));
   //             } else if (d2 < d1 || this.minecraft.hitResult == null) {
   //                this.minecraft.hitResult = entityhitresult;
   //                if (entity1 instanceof LivingEntity || entity1 instanceof ItemFrame) {
   //                   this.minecraft.crosshairPickEntity = entity1;
   //                }
   //             }
   //          }

   //          this.minecraft.getProfiler().pop();
		}
	}
}

GameRenderer_render :: proc(this: ^GameRenderer, f: f32, t: Time, b: bool)
{
// if (!this.minecraft.isWindowActive() && this.minecraft.options.pauseOnLostFocus && (!this.minecraft.options.touchscreen().get() || !this.minecraft.mouseHandler.isRightPressed())) {
//         if (Util.getMillis() - this.lastActiveTime > 500L) {
//            this.minecraft.pauseGame(false);
//         }
//      } else {
//         this.lastActiveTime = Util.getMillis();
//      }

//      if (!this.minecraft.noRender) {
//         int i = (int)(this.minecraft.mouseHandler.xpos() * (double)this.minecraft.getWindow().getGuiScaledWidth() / (double)this.minecraft.getWindow().getScreenWidth());
//         int j = (int)(this.minecraft.mouseHandler.ypos() * (double)this.minecraft.getWindow().getGuiScaledHeight() / (double)this.minecraft.getWindow().getScreenHeight());
//         RenderSystem.viewport(0, 0, this.minecraft.getWindow().getWidth(), this.minecraft.getWindow().getHeight());
//         if (p_109096_ && this.minecraft.level != null) {
//            this.minecraft.getProfiler().push("level");
//            this.renderLevel(p_109094_, p_109095_, new PoseStack());
//            this.tryTakeScreenshotIfNeeded();
//            this.minecraft.levelRenderer.doEntityOutline();
//            if (this.postEffect != null && this.effectActive) {
//               RenderSystem.disableBlend();
//               RenderSystem.disableDepthTest();
//               RenderSystem.enableTexture();
//               RenderSystem.resetTextureMatrix();
//               this.postEffect.process(p_109094_);
//            }
	if !this.minecraft.no_render
	{
		i := int( this.minecraft.mouse_handler.xpos * f64(this.minecraft.window.gui_scaled_width) / f64(this.minecraft.window.width) )
		j := int( this.minecraft.mouse_handler.ypos * f64(this.minecraft.window.gui_scaled_height) / f64(this.minecraft.window.height) )
		blaze.RenderSystem_viewport(0, 0, i32(this.minecraft.window.frame_buffer_width), i32(this.minecraft.window.frame_buffer_height))

		if b && this.minecraft.level != nil
		{
			// this.renderLevel(f, t, new PoseStack());

			// ...
			// ...
			// ...
			blaze.RenderTarget_bind_write(&(this.minecraft.main_render_target), true)
		}

		window := &this.minecraft.window
		blaze.RenderSystem_clear(256, ODIN_OS == .Darwin)

		//         Matrix4f matrix4f = Matrix4f.orthographic(0.0F, (float)((double)window.getWidth() / window.getGuiScale()), 0.0F, (float)((double)window.getHeight() / window.getGuiScale()), 1000.0F, 3000.0F);
		m4f := cm_math.Matrix4f_orthographic(0.0, f32( f64(window.frame_buffer_width) / window.gui_scale ),
			0.0, f32( f64(window.frame_buffer_height) / window.gui_scale ),
			1_000.0, 3_000.0)

		//         RenderSystem.setProjectionMatrix(matrix4f);
		blaze.RenderSystem_set_projection_matrix(&m4f)

		//         PoseStack posestack = RenderSystem.getModelViewStack();
		ps := blaze.RenderSystem_get_model_view_stack()

		//         posestack.setIdentity();
		blaze.PoseStack_set_ident(ps)

		//         posestack.translate(0.0D, 0.0D, -2000.0D);
		blaze.PoseStack_translate(ps, 0.0, 0.0, -2_000.0)

		//         RenderSystem.applyModelViewMatrix();
		blaze.RenderSystem_apply_model_view_matrix()

		//         Lighting.setupFor3DItems();
		blaze.Lighting_setup_for_3D_items()

		//         PoseStack posestack1 = new PoseStack();
		ps1 := blaze.PoseStack_new()

		if b && this.minecraft.level != nil
		{
			// this.minecraft.getProfiler().popPush("gui");
            // if (this.minecraft.player != null) {
            //   float f = Mth.lerp(p_109094_, this.minecraft.player.oPortalTime, this.minecraft.player.portalTime);
            //   float f1 = this.minecraft.options.screenEffectScale().get().floatValue();
            //   if (f > 0.0F && this.minecraft.player.hasEffect(MobEffects.CONFUSION) && f1 < 1.0F) {
            //      this.renderConfusionOverlay(f * (1.0F - f1));
            //   }
            //}

            //if (!this.minecraft.options.hideGui || this.minecraft.screen != null) {
            //   this.renderItemActivationAnimation(this.minecraft.getWindow().getGuiScaledWidth(), this.minecraft.getWindow().getGuiScaledHeight(), p_109094_);
            //   this.minecraft.gui.render(posestack1, p_109094_);
            //   RenderSystem.clear(256, Minecraft.ON_OSX);
            //}

            //this.minecraft.getProfiler().pop();*/
		}

		if this.minecraft.overlay != nil
		{
			LoadingOverlay_render(&(this.minecraft.overlay.?), &ps1, i, j, Minecraft_get_delta_frame_time(this.minecraft))
		} else if this.minecraft.screen != nil
		{

		}
	}
}

GameRenderer_reload_shaders :: proc(this: ^GameRenderer, resmgr: ^ResourceManager)
{
	blaze.RenderSystem_assert_on_render_thread()
	list := make([dynamic]^blaze.Program, 0, 512)

	frag_programs := blaze.Program_Type_get_programs(.Fragment)
	vert_programs := blaze.Program_Type_get_programs(.Vertex)

	for k, _ in frag_programs { append(&list, &(frag_programs^[k])) }
	for k, _ in vert_programs { append(&list, &(vert_programs^[k])) }

	for _, i in list { blaze.Program_close(list[i]) }
}