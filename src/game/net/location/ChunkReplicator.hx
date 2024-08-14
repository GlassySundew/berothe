package game.net.location;

import util.Assert;
import game.net.client.GameClient;
import hxbit.NetworkSerializable.NetworkSerializer;
import hxbit.NetworkHost;
import game.domain.GameCore;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
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
		chunk.entityStream.observe( onEntityAddedToChunk );
	}

	override function alive() {
		super.alive();

		#if client
		entities.subscribleWithMapping( ( entityReplicator ) -> {
			GameClient.inst.currentLocation.onAppear( ( location ) -> {
				entityReplicator.entity.then( ( entity ) -> {
					Assert.notNull( entity );
					location.addEntity( entity );
				} );
			} );
		} );
		#end
	}

	function onEntityAddedToChunk( entity : OverworldEntity ) {
		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entities.push( entityReplicator );
	}
}
