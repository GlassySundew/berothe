package game.domain.overworld.location;

import game.domain.overworld.location.physics.Types;

class Chunks {

	public final chunkSize : Int;

	final chunks : Map<Int, Map<Int, Map<Int, Chunk>>> = [];
	final location : OverworldLocationMain;

	public function new( location : OverworldLocationMain, chunkSize : Int ) {

		this.chunkSize = chunkSize;
		this.location = location;
	}

	public function dispose() {}

	#if !debug inline #end
	public function getChunk( x : Int, y : Int, z : Int ) : Chunk {

		if ( chunks[z] == null )
			chunks[z] = new Map();

		if ( chunks[z][y] == null )
			chunks[z][y] = new Map();

		if ( chunks[z][y][x] == null ) {

			var chunk = chunks[z][y][x] = new Chunk( x, y, z, chunkSize, location );
			// location.onChunkCreated.dispatch( chunk );
		}

		return chunks[z][y][x];
	}

	inline function getChunkIdxFromAbsolute( coords : Vec ) : Vec {

		return new Vec(
			Math.floor( coords.x / chunkSize ),
			Math.floor( coords.y / chunkSize ),
			Math.floor( coords.z / chunkSize )
		);
	}
}
