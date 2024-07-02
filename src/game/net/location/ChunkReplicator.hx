package game.net.location;

import util.Assert;
import game.net.client.GameClient;
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
		chunk.entityStream.observe( onEntityAddedToChunk );
	}

	override function alive() {
		super.alive();

		#if client
		entities.subscribleWithMapping( ( entityReplicator ) -> {
			GameClient.inst.currentLocation.onAppear( ( location ) -> {
				trace( "got entity in chunk: " + entityReplicator.entity.desc );
				Assert.notNull( entityReplicator.entity );
				location.addEntity( entityReplicator.entity );
			} );
		} );
		#end
	}

	function onEntityAddedToChunk( entity : OverworldEntity ) {
		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entities.push( entityReplicator );
	}
}
