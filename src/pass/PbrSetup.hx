package pass;

import hxd.Res;
import h3d.mat.Texture;

class PbrSetup extends h3d.mat.PbrMaterialSetup {

	override function createRenderer() {
		var env = new h3d.scene.pbr.Environment( Res.defaultEnv.toTexture() );
		env.power = 0.4;
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

	var outline = new h3d.pass.ScreenFx( new ScreenOutline() );
	var outlineBlur = new h3d.pass.Blur( 4 );

	public function new( env ) {
		super( env );
	}

	override function getPassByName( name : String ) : h3d.pass.Output {
		switch ( name ) {
			case "highlight", "highlightBack":
				return defaultPass;
		}
		return super.getPassByName( name );
	}

	override function getDefaultProps( ?kind : String ) : Any {
		var props : h3d.scene.pbr.Renderer.RenderProps = super.getDefaultProps( kind );
		props.sky = Background;
		return props;
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

		@param var texture: Sampler2D;

		function fragment() {
			var outval = texture.get(calculatedUV).rgb;
			pixelColor.a = outval.r > 0.1 && outval.r < 0.5 ? 1.0 : 0.0;
			pixelColor.rgb = (outval.r > outval.g ? 0.5 : 1.0).xxx;
		}
	};
}
