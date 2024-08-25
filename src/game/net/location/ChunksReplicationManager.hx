package game.net.location;

import game.domain.overworld.GameCore;
import game.domain.overworld.location.Chunk;
import game.domain.overworld.location.Location;

class ChunksReplicationManager {

	public final chunks : Map<Int, Map<Int, Map<Int, ChunkReplicator>>> = [];
	final location : Location;
	final coreReplicator : CoreReplicator;

	public function new( location : Location, coreReplicator : CoreReplicator ) {
		this.location = location;
		this.coreReplicator = coreReplicator;
		location.onChunkCreated.add( onChunkAdded );
	}

	function onChunkAdded( chunk : Chunk ) {
		validateAccess( chunk.x, chunk.y, chunk.z );
		var chunkRepl = new ChunkReplicator( chunk, coreReplicator );
		chunks[chunk.z][chunk.y][chunk.x] = chunkRepl;
	}

	public function validateAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = new Map();
		if ( chunks[z][y] == null ) chunks[z][y] = new Map();
	}
}
