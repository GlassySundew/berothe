package game.server.level.block;

import oimo.dynamics.World;
import game.client.level.LUTBlockView;
import game.client.level.LevelView;
import oimo.common.Vec3;
import util.oimo.OimoUtil;

class TileBlock extends Block {

	@:s public var tileGid : Int;
	@:s public var tileset : TmxTileset;

	@:s public var depthOff : Int = 0;

	public function new( ?parent : Chunk ) {
		super( parent );
	}

	function createView() {
		var type = tileset.properties.getProp( PTString, "type" );
		switch( type ) {
			case BlockViewType.LUT:
			default:
				trace( "unsupported block type " + type );
		}
	}

	function createPhysics( world : World ) {
		OimoUtil.addBox(
			LevelView.inst.world,
			new Vec3(
				x + ( tileset.tileHeight >> 1 ),
				y + ( tileset.tileHeight >> 1 ),
				z + ( tileset.tileHeight + 1 ) / 2
			),
			new Vec3(
				tileset.tileHeight >> 1,
				tileset.tileHeight >> 1,
				( tileset.tileHeight + 1 ) / 2
			),
			true
		);
	}
}
