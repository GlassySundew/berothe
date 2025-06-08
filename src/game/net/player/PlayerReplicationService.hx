package game.net.player;

import util.Repeater;
import rx.Subscription;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.net.server.GameServer;
import rx.disposables.ISubscription;
import hxbit.NetworkHost;
import net.ClientController;
import rx.disposables.Composite;
import util.Assert;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import game.domain.overworld.location.Location;
import game.net.entity.EntityReplicator;
import game.net.location.ChunkReplicator;
import game.net.CoreReplicator;
import game.net.location.LocationReplicator;

class PlayerSubscribedChunk {

	public var replicator( default, null ) : ChunkReplicator;
	public var subscription : Composite;

	public inline function new(
		replicator : ChunkReplicator
	) {
		this.replicator = replicator;
		subscription = Composite.create();
	}
}

/**
	A server-side only service, `PlayerReplicationService` 
	manages a single player's replication channel
**/
class PlayerReplicationService {

	public static final PLAYER_VISION_RANGE_CHUNKS = 1;

	public final cliCon : ClientController;
	public final playerEntityReplicator : EntityReplicator;
	final playerEntity : OverworldEntity;
	final coreReplicator : CoreReplicator;

	/** chunks that are currently visible by a player **/
	final chunks : Map<Int, Map<Int, Map<Int, PlayerSubscribedChunk>>> = [];

	final sub = Composite.create();

	var locationSub : ISubscription;

	public function new(
		playerEntity : OverworldEntity,
		playerEntityReplicator : EntityReplicator,
		cliCon : ClientController,
		coreReplicator : CoreReplicator
	) {
		this.cliCon = cliCon;
		this.playerEntityReplicator = playerEntityReplicator;
		this.playerEntity = playerEntity;
		this.coreReplicator = coreReplicator;

		init();
	}

	public function onClientDisconnected() {
		if ( !playerEntity.disposed.isTriggered ) playerEntity.dispose();
	}

	function init() {
		sub.add( playerEntity.chunk.addOnValueImmediately( onAddedToChunk ) );
		sub.add( playerEntity.location.addOnValueImmediately( onAddedToLocation ) );
		playerEntity.disposed.then( _ -> {
			sub.unsubscribe();
			wipeAllChunks();
		} );

		cliCon.connect( playerEntityReplicator );
		cliCon.giveControlOverEntity( playerEntityReplicator );

		var transform = playerEntityReplicator.transformRepl;
		transform.x.syncBackOwner = cliCon;
		transform.y.syncBackOwner = cliCon;
		transform.z.syncBackOwner = cliCon;

		transform.velX.syncBackOwner = cliCon;
		transform.velY.syncBackOwner = cliCon;
		transform.velZ.syncBackOwner = cliCon;

		transform.rotationX.syncBackOwner = cliCon;
		transform.rotationY.syncBackOwner = cliCon;
		transform.rotationZ.syncBackOwner = cliCon;

		playerEntity.transform.onTakeControl.add( takeControl );
		playerEntity.transform.onReleaseControl.add( giveControl );

		giveControl();
	}

	function giveControl() {
		// wait for client response flush
		cliCon.pingClient( ( _ ) -> {
			var transform = playerEntityReplicator.transformRepl;
			transform.ignoreSync = false;

			transform.x.syncBack = false;
			transform.y.syncBack = false;
			transform.z.syncBack = false;

			transform.velX.syncBack = false;
			transform.velY.syncBack = false;
			transform.velZ.syncBack = false;

			transform.rotationX.syncBack = false;
			transform.rotationY.syncBack = false;
			transform.rotationZ.syncBack = false;
		} );
	}

	function takeControl() {
		var transform = playerEntityReplicator.transformRepl;
		transform.ignoreSync = true;

		transform.x.syncBack = true;
		transform.y.syncBack = true;
		transform.z.syncBack = true;

		transform.velX.syncBack = true;
		transform.velY.syncBack = true;
		transform.velZ.syncBack = true;

		transform.rotationX.syncBack = true;
		transform.rotationY.syncBack = true;
		transform.rotationZ.syncBack = true;
	}

	/** 
		@return true if new subscription was created 
	**/
	function validateChunkAccess( x : Int, y : Int, z : Int ) : Bool {
		if ( chunks[z] == null ) chunks[z] = new Map();
		if ( chunks[z][y] == null ) chunks[z][y] = new Map();
		if ( chunks[z][y][x] == null ) {
			var locationReplManager : LocationReplicator //
				= coreReplicator.getLocationReplicator( playerEntity.location.getValue() );
			chunks[z][y][x] = new PlayerSubscribedChunk(
				locationReplManager.getChunkReplicator( x, y, z )
			);

			Assert.notNull( chunks[z][y][x].replicator, "chunk replicator is null" );

			return true;
		} else {
			return false;
		}
	}

	#if !debug inline #end
	function areChunksInRange(
		chunk1 : Chunk,
		chunk2 : Chunk,
		range : Int
	) : Bool {
		return(
			Math.abs( chunk1.x - chunk2.x ) <= range
			&& Math.abs( chunk1.y - chunk2.y ) <= range
			&& Math.abs( chunk1.z - chunk2.z ) <= range
		);
	}

	function wipeAllChunks() {
		for ( zChunkRow in chunks ) {
			for ( yChunkRow in zChunkRow ) {
				for ( xi => xChunkRepl in yChunkRow ) {
					xChunkRepl.subscription.unsubscribe();
					cliCon.removeChild( xChunkRepl.replicator );
					xChunkRepl.replicator.unregister(
						NetworkHost.current,
						cliCon.networkClient.ctx
					);
				}
			}
		}
		chunks.clear();
	}

	function clearChunksOutOfRange( oldChunk : Chunk, newChunk : Chunk ) {
		for ( zChunkRow in chunks ) {
			for ( yChunkRow in zChunkRow ) {
				for ( xi => xChunkRepl in yChunkRow ) {
					if ( !areChunksInRange(
						newChunk,
						xChunkRepl.replicator.chunk,
						PLAYER_VISION_RANGE_CHUNKS
					) ) {
						xChunkRepl.subscription.unsubscribe();
						yChunkRow.remove( xi );
						cliCon.removeChild( xChunkRepl.replicator );
						xChunkRepl.replicator.unregister(
							NetworkHost.current,
							cliCon.networkClient.ctx
						);
					}
				}
			}
		}
	}

	function attachVisibleChunks( newChunk : Chunk ) {
		final range = PLAYER_VISION_RANGE_CHUNKS;
		for ( z in newChunk.z - range...newChunk.z + range + 1 ) {
			for ( y in newChunk.y - range...newChunk.y + range + 1 ) {
				for ( x in newChunk.x - range...newChunk.x + range + 1 ) {

					var wasUnseen = validateChunkAccess( x, y, z );
					if ( wasUnseen ) {
						var chunkRepl = chunks[z][y][x];
						cliCon.connect( chunkRepl.replicator );

						chunkRepl.subscription.add(
							chunkRepl.replicator.chunk.onEntityRemoved.add( onEntityRemovedFromChunk )
						);
					}
				}
			}
		}
	}

	function onEntityRemovedFromChunk( entity : OverworldEntity ) {
		if ( entity == playerEntity ) return;

		// допущение: мы полагаем что `entity` пока не поменял свой чанк и
		// он поменяется после выполнения этой функции
		entity.chunk.addOnValue( ( _, entityChunk ) -> {
			if (
				entityChunk != null
				&& !areChunksInRange(
					entityChunk,
					playerEntity.chunk.getValue(),
					PLAYER_VISION_RANGE_CHUNKS
				) ) {
					var entityReplicator = coreReplicator.getEntityReplicator( entity );
					entityReplicator.unregister(
						NetworkHost.current,
						cliCon.networkClient.ctx
					);
			}
		}, 1 );
	}

	function onAddedToChunk( oldChunk : Chunk, chunk : Chunk ) {
		if ( chunk == null || playerEntity.location.getValue() == null ) {
			return;
		}

		clearChunksOutOfRange( oldChunk, chunk );

		attachVisibleChunks( chunk );
	}

	function onAddedToLocation( oldLoc : Location, location : Location ) {
		locationSub?.unsubscribe();

		if ( oldLoc != null ) wipeAllChunks();

		if ( location == null ) {
			return;
		}

		cliCon.onControlledEntityLocationChange( location.locationDesc.id );

		// attachVisibleChunks( playerEntity.chunk.getValue() );
		// locationSub = location.onEntityRemoved.add( locationOnEntityRemoved );
	}

	function locationOnEntityRemoved( entity : OverworldEntity ) {
		if ( entity == playerEntity || entity.disposed.isTriggered ) return;

		var entityReplicator = coreReplicator.getEntityReplicator( entity );
		entityReplicator.unregister(
			NetworkHost.current,
			cliCon.networkClient.ctx
		);
	}
}
