package game.core.rules.overworld.location;

import rx.Observable;
import rx.subjects.Replay;
import hrt.prefab.Cache;
import game.core.rules.overworld.entity.OverworldEntity;

class Chunks {

	final chunkSize : Int;
	final location : Location;
	final chunks : Map<Int, Map<Int, Map<Int, Chunk>>> = [];

	public function new( location : Location, chunkSize : Int ) {
		this.chunkSize = chunkSize;
		this.location = location;
	}

	public function placeEntity( entity : OverworldEntity ) {
		var chunkX = Std.int( entity.transform.x.val / chunkSize );
		var chunkY = Std.int( entity.transform.y.val / chunkSize );
		var chunkZ = Std.int( entity.transform.z.val / chunkSize );

		validateChunkAccess( chunkX, chunkY, chunkZ );

		chunks[chunkZ][chunkY][chunkX].addEntity( entity );
	}

	public function validateChunkAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = new Map();
		if ( chunks[z][y] == null ) chunks[z][y] = new Map();
		if ( chunks[z][y][x] == null ) {
			var chunk : Chunk = chunks[z][y][x] = new Chunk( x, y, z, location );
			location.onChunkCreated.dispatch( chunk );
		}
	}
}
