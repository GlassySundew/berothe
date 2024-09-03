package pass;

import h3d.Engine;
import util.Util;
import h3d.scene.Mesh;
import h3d.Vector;
import h3d.pass.PassObject;
import h3d.pass.PassList;

class DefaultForwardComposite extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;
		@param var outline : Sampler2D;
		function fragment() {
			pixelColor = texture.get( calculatedUV );
			var outval = outline.get( calculatedUV );

			var l = 0.2126 * outval.r + 0.7152 * outval.g + 0.0722 * outval.b;

			if ( //
				outval.a > 0.05 && outval.a < 0.99
			) {
				var l = 0.2126 * pixelColor.r + 0.7152 * pixelColor.g + 0.0722 * pixelColor.b;
				if ( l > 0.75 ) {
					pixelColor = outval * 4.0 + 0.1;
				} else {
					pixelColor += outval * 3.0 + 0.1;
				}
			}
		}
	}
}

typedef Point = { var x : Float; var y : Float; }

typedef Line = { var pt1 : Point; var pt2 : Point; }

class CustomRenderer extends h3d.scene.fwd.Renderer {

	public var saoBlur : h3d.pass.Blur;
	public var enableSao : Bool;
	public var enableFXAA : Bool;

	public var mrt : h3d.pass.Output;
	public var fog : pass.Fog;
	public var sao : h3d.pass.ScalableAO;
	public var emissive : pass.Emissive;
	public var fxaa : h3d.pass.FXAA;
	public var post : pass.PostProcessing;
	public var depthColorMap( default, set ) : h3d.mat.Texture;

	public static var inst : CustomRenderer;

	var depthColorMapId : Int;
	var depthColorMax : Int;
	var out : h3d.mat.Texture;
	var composite : h3d.pass.ScreenFx<DefaultForwardComposite>;
	var outlineBlur = new h3d.pass.Blur( 5, 1.2 );

	public function new() {
		super();
		inst = this;
		var engine = h3d.Engine.getCurrent();
		if ( !engine.driver.hasFeature( MultipleRenderTargets ) )
			throw "engine must have MRT";
		mrt = new h3d.pass.Output(
			"mrt", [
				Value( "output.color" ),
				PackFloat( Value( "output.depth" ) ),
				PackNormal( Value( "output.normal" ) )
			]
		);
		allPasses.push( mrt );

		depthColorMap = h3d.mat.Texture.fromColor( 0xFFFFFF );
		depthColorMapId = hxsl.Globals.allocID( "depthColorMap" );

		sao = new h3d.pass.ScalableAO();
		saoBlur = new h3d.pass.Blur();

		sao.shader.sampleRadius = 0.2;
		fog = new pass.Fog();

		fxaa = new h3d.pass.FXAA();
		shadow.power = 4.6;
		shadow.blur.quality = 1.0;
		shadow.size = Std.int( Math.pow( 2, Std.int( 9 ) ) );
		shadow.blur.radius = 2.9;

		sao.shader.numSamples = 32;
		sao.shader.bias = 0.008;
		sao.shader.intensity = 5.5;
		sao.shader.sampleRadius = 6;
		saoBlur.radius = 6.6;
		saoBlur.quality = 1.1;

		enableFXAA = true;

		emissive = new pass.Emissive( "emissive" );
		emissive.reduceSize = 1;
		// emissive.blur.passes = 5;
		emissive.blur.quality = 4;

		// emissive.blur.sigma = 2;
		post = new pass.PostProcessing();

		composite = new h3d.pass.ScreenFx( new DefaultForwardComposite() );

		frontToBack = depthSort.bind( true );
		backToFront = depthSort.bind( false );
	}

	function set_depthColorMap( v : h3d.mat.Texture ) {
		var pixels = v.capturePixels();
		depthColorMax = pixels.getPixel( pixels.width - 1, 0 );
		// mrt.clearColors[0] = depthColorMax;
		return depthColorMap = v;
	}

	function sortIsoPoly( passes : PassList ) {
		passes.sort( function ( o1, o2 ) {
			return -1;
		} );
	}

	override function render() {
		renderPass( shadow, get( "shadow" ) );
		var colorTex = allocTarget( "color" );
		var depthTex = allocTarget( "depth" );
		var normalTex = allocTarget( "normal" );
		// var additiveTex = allocTarget( "additive" );
		setTargets( [colorTex, depthTex, normalTex /*, additiveTex*/] );
		clear( Engine.getCurrent().backgroundColor, 1 );
		mrt.draw( get( "default" ) );
		defaultPass.draw( get( "alpha" ), backToFront );
		// !additive
		resetTarget();

		var saoTarget = allocTarget( "sao" );
		setTarget( saoTarget );
		sao.apply( depthTex, normalTex, ctx.camera );
		resetTarget();
		saoBlur.apply( ctx, saoTarget );
		if ( enableFXAA )
			fxaa.apply( colorTex )
		else copy( colorTex, null );

		post.apply( colorTex, ctx.time );

		var outlineTex = allocTarget( "outlineBlur", false );
		var outlineSrcTex = allocTarget( "outline", true );
		setTarget( outlineSrcTex );
		clear( 0 );
		// draw("highlightBack");
		draw( "highlight" );
		resetTarget();
		outlineBlur.apply( ctx, outlineSrcTex, outlineTex );
		composite.shader.outline = outlineTex;

		resetTarget();
		composite.shader.texture = colorTex;
		composite.render();

		copy( saoTarget, null, Multiply );
	}

	public function flash( color : Int, duration : Float ) {
		post.flash( color, ctx.time, duration );
	}

	// @:access( h3d.scene.Object )
	// public override function depthSort( frontToBack : Bool, passes : PassList ) {
	// 	passes.sort( sortPasses );
	// }

	function sortPasses( p1 : PassObject, p2 : PassObject ) {
		return
			( p1.depth > p2.depth ? -1 : 1 );
	}

	inline function comparePointAndLine( pt : Point, line : Line ) : Int {
		if ( pt.y > line.pt1.y && pt.y > line.pt2.y ) {
			return -1;
		} else if ( pt.y < line.pt1.y && pt.y < line.pt2.y ) {
			return 1;
		} else {
			var slope = ( line.pt2.y - line.pt1.y ) / ( line.pt2.x - line.pt1.x );
			var intercept = line.pt1.y - ( slope * line.pt1.x );
			return(( slope * pt.x ) + intercept ) > pt.y ? 1 : -1;
		}
	}

	inline function compareLineAndLine( line1 : Line, line2 : Line ) {
		var comp1 = comparePointAndLine( line1.pt1, line2 );
		var comp2 = comparePointAndLine( line1.pt2, line2 );
		var oneVStwo = comp1 == comp2 ? comp1 : -2;

		var comp3 = comparePointAndLine( line2.pt1, line1 );
		var comp4 = comparePointAndLine( line2.pt2, line1 );
		var twoVSone = comp3 == comp4 ? -comp3 : -2;

		if ( oneVStwo != -2 && twoVSone != -2 ) {
			if ( oneVStwo == twoVSone ) {
				return oneVStwo;
			}
			return compareLineCenters( line1, line2 );
		} else if ( oneVStwo != -2 ) return oneVStwo;
		else if ( twoVSone != -2 ) return twoVSone;
		else return compareLineCenters( line1, line2 );
	}

	inline function compareLineCenters( line1 : Line, line2 : Line ) {
		return centerHeight( line1 ) > centerHeight( line2 ) ? -1 : 1;
	}

	inline function centerHeight( line : Line ) return( line.pt1.y + line.pt2.y ) / 2;
}
