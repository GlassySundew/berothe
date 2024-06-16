package game.net.location;

import game.core.GameCore;
import game.core.rules.overworld.location.Location;

class LocationReplicationManager {

	final location : Location;
	final chunksReplicator : ChunksReplicationManager;
	final coreReplicator : CoreReplicator;

	/* 
		как только `LocationReplicationManager` 
		ещё что-то захочет, надо обернуть все аргументы 
		в `NetworkReplicationService` dto
		с удобным интерфейсом для вытаскивания репликаторов 
		сущностей и т.д.
	 */
	public function new( location : Location, coreReplicator : CoreReplicator ) {
		this.location = location;
		this.coreReplicator = coreReplicator;
		chunksReplicator = new ChunksReplicationManager( location, coreReplicator );
	}

	public function getChunkReplicator( x : Int, y : Int, z : Int ) : ChunkReplicator {
		location.chunks.validateChunkAccess( x, y, z );
		return chunksReplicator.chunks[z][y][x];
	}
}
