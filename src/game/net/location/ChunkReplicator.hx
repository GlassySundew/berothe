package game.net.location;

import util.Assert;
import game.net.client.GameClient;
import hxbit.NetworkSerializable.NetworkSerializer;
import hxbit.NetworkHost;
import game.domain.overworld.GameCore;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import net.NSArray;
import game.net.entity.EntityReplicator;
import net.NetNode;

class ChunkReplicator extends NetNode {

	@:s
	var entities : NSArray<EntityReplicator> = new NSArray();

	@:s var x: Int;
	@:s var y: Int;
	@:s var z: Int;
	
	public final chunk : Chunk;

	final coreReplicator : CoreReplicator;

	public function new( chunk : Chunk, coreReplicator : CoreReplicator, ?parent ) {
		super( parent );
		this.chunk = chunk;
		x = chunk.x;
		y = chunk.y;
		z = chunk.z;
		this.coreReplicator = coreReplicator;
		chunk.entityStream.observe( onEntityAddedToChunk );
		chunk.onEntityRemoved.add( onEntityRemovedFromChunk );
	}

	override public function unregister(
		host : NetworkHost,
		?ctx : NetworkSerializer
	) @:privateAccess {
		for ( entity in entities ) {
			entity.unregister( host, ctx );
		}
		host.unregister( entities, ctx );
		super.unregister( host, ctx );
	}

	override public function alive() {
		super.alive();

		#if client
		entities.subscribleWithMapping( ( entityReplicator ) -> {
			GameClient.inst.currentLocation.onAppear( ( location ) -> {
				entityReplicator.entity.then( ( entity ) -> {
					Assert.notNull( entity );
					if ( !location.hasEntity( entity ) )
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

	function onEntityRemovedFromChunk( entity : OverworldEntity ) {
		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entities.remove( entityReplicator );
	}
}
