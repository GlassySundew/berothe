package game.core.rules.overworld.location;

import hrt.prefab.Cache;
import game.core.rules.overworld.entity.OverworldEntity;

class Chunks {

	var chunks : Array<Array<Array<Chunk>>> = [];

	final chunkSize : Int;

	public function new( chunkSize : Int ) {
		this.chunkSize = chunkSize;
	}

	public function placeEntity( entity : OverworldEntity ) {
		var chunkX = Std.int( entity.transform.x.val / chunkSize );
		var chunkY = Std.int( entity.transform.y.val / chunkSize );
		var chunkZ = Std.int( entity.transform.z.val / chunkSize );

		validateChunkAccess( chunkX, chunkY, chunkZ );

		chunks[chunkZ][chunkY][chunkX].addEntity( entity );
	}

	function validateChunkAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = [];
		if ( chunks[z][y] == null ) chunks[z][y] = [];
		if ( chunks[z][y][x] == null ) chunks[z][y][x] = new Chunk();
	}
}
