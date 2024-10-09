package pass;

import h3d.mat.Texture;
import h3d.pass.Output;

class Emissive extends Output {

	var emissiveMapId : Int;

	public var outputTex : Texture;
	public var reduceSize : Int = 0;
	public var blur : h3d.pass.Blur;

	public function new( name ) {
		super( name );
		emissiveMapId = hxsl.Globals.allocID( "emissiveMap" );
		blur = new h3d.pass.Blur( 2, 3 );
	}

	function getOutputs() : Array<hxsl.Output> {
		return [Value( "emissiveColor" )];
	}

	override function draw( passes : h3d.pass.PassList, ?sort : h3d.pass.PassList -> Void ) {
		outputTex = ctx.textures.allocTarget( "emissiveMap", ctx.engine.width >> reduceSize, ctx.engine.height >> reduceSize, false );
		var captureTex = ctx.textures.allocTarget( "captureTex", ctx.engine.width, ctx.engine.height, true );

		ctx.engine.pushTarget( captureTex );
		ctx.engine.clear( 0 );
		super.draw( passes );
		ctx.engine.popTarget();

		h3d.pass.Copy.run( captureTex, outputTex, None );
		blur.apply( ctx, captureTex, outputTex );

		ctx.setGlobal( '$emissiveMapId', { texture : outputTex } );

		// return passes;
	}
}
