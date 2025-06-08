package pass;

import h2d.Tile;
import h2d.Bitmap;
import h3d.Vector;
import h3d.Camera;
import hxd.Res;
import h3d.mat.Texture;

class PbrSetup extends h3d.mat.PbrMaterialSetup {

	override function createRenderer() {
		var env = new h3d.scene.pbr.Environment( Res.defaultEnv.toTexture() );
		env.power = 0.7;
		env.compute();
		return new PbrRenderer( env );
	}

	override function getDefaults( ?type : String ) : Any {
		if ( type == "ui" ) return {
			mode : "Overlay",
			blend : "Alpha",
			shadows : false,
			culled : false,
			lighted : false
		};
		return super.getDefaults( type );
	}
}

class PbrRenderer extends h3d.scene.pbr.Renderer {

	public var saoBlur : h3d.pass.Blur;
	public var sao : h3d.pass.ScalableAO;

	var outline = new h3d.pass.ScreenFx( new ScreenOutline() );
	var outlineBlur = new h3d.pass.Blur( 4 );
	var controlCharDepth : Texture;

	final controlCharacterPos : h3d.Vector = new Vector();
	final controlCam : h3d.Camera = new Camera();
	final characterDepth : CharacterDepth = new CharacterDepth();

	public function new( env ) {
		super( env );

		sao = new h3d.pass.ScalableAO();
		saoBlur = new h3d.pass.Blur();
		sao.shader.sampleRadius = 0.2;
		sao.shader.numSamples = 30;

		controlCam.zNear = 0.1;
		controlCam.zFar = 10000;
		controlCam.fovY = 179;
	}

	override function getPassByName( name : String ) : h3d.pass.Output {
		switch ( name ) {
			case "highlight", "highlightBack":
				return defaultPass;
				case "stencil":
					return output;
		}
		return super.getPassByName( name );
	}

	override function getDefaultProps( ?kind : String ) : Any {
		var props : h3d.scene.pbr.Renderer.RenderProps = super.getDefaultProps( kind );
		props.sky = Background;
		return props;
	}

	public function renderCharacterDepth() {

		// var transform = GameClient.inst.controlledEntity.val?.entity.result?.transform;
		// if ( transform == null ) return;
		// controlCharacterPos.set( transform.x, transform.y, transform.z );
		// characterDepth.shader.characterPos.x = transform.x;
		// characterDepth.shader.characterPos.y = transform.y;
		// characterDepth.shader.characterPos.z = transform.z;

		// controlCam.pos.x = controlCharacterPos.x;
		// controlCam.pos.y = controlCharacterPos.y;
		// controlCam.pos.z = controlCharacterPos.z;

		// var mainCam = ctx.camera;
		// ctx.setCamera( controlCam );
		// initGlobals();

		// setTarget( controlCharDepth );
		// ctx.engine.clearF( new h3d.Vector4( 1 ) );
		// renderPass( output, get( "default" ) );

		// ctx.setCamera( mainCam );
		// initGlobals();
	}

	override function initTextures() {
		super.initTextures();
		// controlCharDepth = allocTarget( "characterDepth", true, 1., R32F );

		// new Bitmap( Tile.fromTexture( controlCharDepth ), Boot.inst.s2d ).scale( 0.25 );
	}

	override function render() {
		beginPbr();
		// renderCharacterDepth();

		setTarget( textures.depth );
		ctx.engine.clearF( new h3d.Vector4( 1 ) );

		setTargets( getPbrRenderTargets( false ) );
		clear( 0, 1, 0 );

		setTargets( getPbrRenderTargets( true ) );

		begin( MainDraw );
		renderPass( output, get( "terrain" ) );
		drawPbrDecals( "terrainDecal" );
		renderPass( output, get( "default" ), frontToBack );
		renderPass( output, get( "alpha" ), backToFront );
		renderPass( output, get( "additive" ) );
		renderPass( output, get( "stencil" ), frontToBack );
		end();
		
		// var saoTarget = allocTarget( "sao" );
		// setTarget( saoTarget );
		// sao.apply(
		// 	ctx.getGlobal( "depthMap" ).texture,
		// 	ctx.getGlobal( "normalMap" ).texture,
		// 	ctx.camera
		// );
		// resetTarget();
		// saoBlur.apply( ctx, saoTarget );
		// copy( ctx.getGlobal( "depthMap" ), null );
		// copy( saoTarget, null, Multiply );

		begin( Decals );
		drawPbrDecals( "decal" );
		// drawEmissiveDecals( "emissiveDecal" );
		end();

		setTarget( textures.hdr );
		clear( 0 );
		lighting();

		begin( Forward );
		var ls = Std.downcast( getLightSystem(), h3d.scene.pbr.LightSystem );
		ls.forwardMode = true;
		setTargets( [textures.hdr, getPbrDepth()] );
		renderPass( colorDepthOutput, get( "forward" ) );
		setTarget( textures.hdr );
		renderPass( defaultPass, get( "forwardAlpha" ), backToFront );
		ls.forwardMode = false;
		end();

		if ( renderMode == LightProbe ) {
			resetTarget();
			copy( textures.hdr, null );
			// no warnings
			for ( p in passObjects ) if ( p != null ) p.rendered = true;
			return;
		}

		begin( BeforeTonemapping );
		draw( "beforeTonemappingDecal" );
		draw( "beforeTonemapping" );
		end();

		setTarget( textures.ldr );
		tonemap.render();

		begin( AfterTonemapping );
		draw( "afterTonemappingDecal" );
		draw( "afterTonemapping" );
		end();

		begin( Overlay );
		draw( "overlay" );
		end();

		endPbr();
	}

	override function endPbr() {
		// resetTarget();
		switch ( displayMode ) {
			case Pbr, Env, MatCap:
				// characterDepth.apply( controlCharDepth );

			default:
		}

		super.endPbr();
	}

	override function end() {
		renderOutlines();
		super.end();
	}

	inline function renderOutlines() {
		renderPass( defaultPass, get( "debuggeom" ), backToFront );
		renderPass( defaultPass, get( "debuggeom_alpha" ), backToFront );

		var outlineTex = allocTarget( "outline", true );
		ctx.engine.pushTarget( outlineTex );
		clear( 0 );
		draw( "highlight" );
		ctx.engine.popTarget();
		var outlineBlurTex = allocTarget( "outlineBlur", false );
		outline.pass.setBlendMode( Alpha );
		outlineBlur.apply( ctx, outlineTex, outlineBlurTex );
		outline.shader.texture = outlineBlurTex;
		outline.render();

		renderPass( defaultPass, get( "ui" ), backToFront );
	}
}

class ScreenOutline extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;
		function fragment() {
			var outval = texture.get( calculatedUV ).rgb;
			pixelColor.a = outval.r > 0.1 && outval.r < 0.5 ? 1.0 : 0.0;
			pixelColor.rgb = ( outval.r > outval.g ? 0.5 : 1.0 ).xxx;
		}
	};
}
