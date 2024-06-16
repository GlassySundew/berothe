package game.net.location;

import hxbit.NetworkSerializable.NetworkSerializer;
import hxbit.NetworkHost;
import game.core.GameCore;
import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.location.Chunk;
import net.NSArray;
import game.net.entity.EntityReplicator;
import net.NetNode;

class ChunkReplicator extends NetNode {

	@:s var entities : NSArray<EntityReplicator> = new NSArray();

	public final chunk : Chunk;

	final coreReplicator : CoreReplicator;

	public function new( chunk : Chunk, coreReplicator : CoreReplicator, ?parent ) {
		super( parent );
		this.chunk = chunk;
		this.coreReplicator = coreReplicator;
		chunk.onEntityAdded.add( onEntityAddedToChunk );
	}

	override function alive() {
		super.alive();
	}

	function onEntityAddedToChunk( entity : OverworldEntity ) {
		// entities.unregisterChild( coreReplicator.getEntityReplicator( entity ), NetworkHost.current );
	}
}
