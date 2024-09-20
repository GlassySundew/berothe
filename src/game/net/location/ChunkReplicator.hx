package game.net.location;

import game.net.CoreReplicator;
import util.Settings;
import rx.disposables.Composite;
import rx.Subscription;
import h3d.col.Point;
import h3d.scene.Graphics;
import util.Assert;
import game.net.client.GameClient;
import hxbit.NetworkSerializable.NetworkSerializer;
import hxbit.NetworkHost;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import net.NSArray;
import game.net.entity.EntityReplicator;
import net.NetNode;

class ChunkReplicator extends NetNode {

	public static var chunkCount = 0;

	@:s
	var entities : NSArray<EntityReplicator> = new NSArray();

	@:s var x : Int;
	@:s var y : Int;
	@:s var z : Int;

	public final chunk : Chunk;

	final coreReplicator : CoreReplicator;

	var binderUnregClient : Composite = Composite.create();

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
		entities.unregister( host, ctx );
		super.unregister( host, ctx );
	}

	override function onUnregisteredClient() {
		super.onUnregisteredClient();
		binderUnregClient.unsubscribe();
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
		drawDebug();
		#end
	}

	function onEntityAddedToChunk( entity : OverworldEntity ) {
		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entities.push( entityReplicator );
	}

	function onEntityRemovedFromChunk( entity : OverworldEntity ) {
		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entities.remove( entityReplicator );
		
		// if ( entity.disposed.isTriggered )
		// 	entityReplicator.unregister( NetworkHost.current );
	}

	#if( client && debug )
	function drawDebug() {
		var graphics = new Graphics( Boot.inst.s3d );
		graphics.material.props = h3d.mat.MaterialSetup.current.getDefaults( "ui" );
		graphics.material.mainPass.depth( false, Always );
		graphics.material.mainPass.setPassName( "ui" );

		graphics.lineStyle( 2, 0x1a3c99, 0.7 );

		Settings.inst.params.debug.chunksDebugVisible.addOnValueImmediately(
			( _, val ) -> graphics.visible = val
		);

		binderUnregClient.add(
			GameClient.inst.onUpdate.add(() -> {
				if ( !graphics.visible ) return;
				graphics.clear();

				var size = GameClient.inst.currentLocation.getValue().locationDesc.chunkSize;

				var x = x * size;
				var y = y * size;
				var z = z * size;

				graphics.drawLine( new Point( x, y, z ), new Point( x + size, y, z ) );
				graphics.drawLine( new Point( x, y, z ), new Point( x, y, z + size ) );
				graphics.drawLine( new Point( x, y, z ), new Point( x, y + size, z ) );

				graphics.drawLine( new Point( x + size, y, z + size ), new Point( x + size, y, z ) );
				graphics.drawLine( new Point( x + size, y, z + size ), new Point( x, y, z + size ) );
				graphics.drawLine( new Point( x + size, y, z + size ), new Point( x + size, y + size, z + size ) );

				graphics.drawLine( new Point( x + size, y + size, z ), new Point( x + size, y + size, z + size ) );
				graphics.drawLine( new Point( x + size, y + size, z ), new Point( x, y + size, z ) );
				graphics.drawLine( new Point( x + size, y + size, z ), new Point( x + size, y, z ) );

				graphics.drawLine( new Point( x, y + size, z + size ), new Point( x, y, z + size ) );
				graphics.drawLine( new Point( x, y + size, z + size ), new Point( x + size, y + size, z + size ) );
				graphics.drawLine( new Point( x, y + size, z + size ), new Point( x, y + size, z ) );
			} )
		);

		binderUnregClient.add(
			Subscription.create(
				() -> {
					graphics.clear();
					graphics.remove();
				}
			)
		);
	}
	#end
}
