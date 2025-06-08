package game.net.location;

import game.net.CoreReplicator;
import net.NetNode;
import game.domain.overworld.location.Location;

class LocationReplicator {

	public final locationDescriptionId : String;

	final location : Location;
	final chunksReplicator : ChunksReplicationManager;
	final coreReplicator : CoreReplicator;

	public function new( location : Location, coreReplicator : CoreReplicator ) {
		locationDescriptionId = location.locationDesc.id;
		this.location = location;
		this.coreReplicator = coreReplicator;
		chunksReplicator = new ChunksReplicationManager( location, coreReplicator );
	}

	public function dispose() {
		chunksReplicator.dispose();
	}

	public function getChunkReplicator( x : Int, y : Int, z : Int ) : ChunkReplicator {
		// location.chunks.validateChunkAccess( x, y, z );
		return chunksReplicator.chunks[z][y][x];
	}
}
