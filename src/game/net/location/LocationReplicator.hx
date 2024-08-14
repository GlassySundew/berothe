package game.net.location;

import net.NetNode;
import game.domain.overworld.location.Location;

class LocationReplicator extends NetNode {

	@:s public final locationDescriptionId : String;

	final location : Location;
	final chunksReplicator : ChunksReplicationManager;
	final coreReplicator : CoreReplicator;

	public function new( location : Location, coreReplicator : CoreReplicator, ?parent ) {
		super( parent );
		locationDescriptionId = location.locationDesc.id;
		this.location = location;
		this.coreReplicator = coreReplicator;
		chunksReplicator = new ChunksReplicationManager( location, coreReplicator );
	}

	public function getChunkReplicator( x : Int, y : Int, z : Int ) : ChunkReplicator {
		location.chunks.validateChunkAccess( x, y, z );
		return chunksReplicator.chunks[z][y][x];
	}

	override function alive() {
		super.alive();
		
	}
}
