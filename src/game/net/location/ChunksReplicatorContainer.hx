package game.net.location;

import game.core.rules.overworld.location.Chunk;
import game.core.rules.overworld.location.Location;

class ChunksReplicatorContainer {

	public final chunks : Array<Array<Array<ChunkReplicator>>> = [];
	final location : Location;

	public function new( location : Location ) {
		this.location = location;
		location.onChunkCreated.add( onChunkAdded );
	}

	function onChunkAdded( chunk : Chunk ) {
		validateAccess( chunk.x, chunk.y, chunk.z );
		var chunkRepl = new ChunkReplicator( chunk );
		chunks[chunk.z][chunk.y][chunk.x] = chunkRepl;
	}

	function validateAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = [];
		if ( chunks[z][y] == null ) chunks[z][y] = [];
	}
}
