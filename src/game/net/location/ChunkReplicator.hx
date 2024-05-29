package game.net.location;

import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.location.Chunk;
import net.NSArray;
import game.net.entity.EntityReplicator;
import net.NetNode;

class ChunkReplicator extends NetNode {

	@:s var entities : NSArray<EntityReplicator> = new NSArray();

	final chunk : Chunk;

	public function new( chunk : Chunk, ?parent ) {
		super( parent );
		this.chunk = chunk;
		chunk.onEntityAdded.add( onEntityAddedToChunk );
	}

	function onEntityAddedToChunk( entity : OverworldEntity ) {
		entities.push( new EntityReplicator(entity) );
	}
}
