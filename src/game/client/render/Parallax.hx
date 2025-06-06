package game.client.render;

import game.net.client.GameClient;
import util.GameUtil;
import h2d.RenderContext;
import util.Util;
import h2d.Object;
import dn.M;
import ch3.scene.TileSprite;
import dn.heaps.slib.HSprite;
import h2d.Tile;
import h3d.Vector;
import h3d.mat.Texture;
import shader.DepthOffset;
import util.Assets;

class Parallax extends Object {

	var spr : HSprite;

	// var tex : Texture;
	var cameraX = 0.;
	var cameraY = 0.;

	public var parallaxEffect = new Vector( .5, .5 );

	public function new( ?parent : Object ) {
		super( parent );
		
		spr = new HSprite( Assets.env );

		drawParallax();

		ClientMain.inst.delayer.addF(() -> {
			if ( GameClient.inst != null ) @:privateAccess {
				cameraX = GameClient.inst.cameraProc.cameraController.targetOffset.x;
				cameraY = GameClient.inst.cameraProc.cameraController.targetOffset.y;
			}
		}, 2 );
		// mesh.scale( .5 );
		// mesh.alwaysSync = true;
	}

	public function drawParallax() {
		// tex.wrap = Repeat;

		// tex.filter = Nearest;
		for ( i in 0...5 ) {
			var tileGroup = new h2d.TileGroup( spr.tile, this);

			for ( i in 0...Std.int( Random.int( 100, 200 ) * GameUtil.hScaled / 720 ) ) {
				spr.set( Assets.env, Random.fromArray( [
					"red_star_big",
					"blue_star_big",
					"yellow_star_big",
					"blue_star_small",
					"red_star_small",
					"yellow_star_small"
				] ) );
				tileGroup.add( Std.random( GameUtil.wScaled ), Std.random( GameUtil.hScaled ), spr.tile );
			}
			var tex = new Texture( GameUtil.wScaled, GameUtil.wScaled, [Target] );
		}

		// if ( mesh != null ) {
		// 	mesh.tile = Tile.fromTexture( tex );
		// 	mesh.tile = mesh.tile.center();
		// }
	}

	override function sync( ctx : RenderContext ) @:privateAccess {
		super.sync( ctx );
		// if ( LevelView.inst != null && GameClient.inst != null ) {
			var deltaX = GameClient.inst.cameraProc.cameraController.targetOffset.x - cameraX;
			var deltaY = GameClient.inst.cameraProc.cameraController.targetOffset.y - cameraY;

			// mesh.tile.scrollDiscrete( deltaX * parallaxEffect.x, deltaY * parallaxEffect.y );
			// mesh.tile = mesh.tile;

			cameraX = GameClient.inst.cameraProc.cameraController.targetOffset.x;
			cameraY = GameClient.inst.cameraProc.cameraController.targetOffset.y;
		// }
	}
}
