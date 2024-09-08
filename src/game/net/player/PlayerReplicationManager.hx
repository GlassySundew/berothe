package game.net.player;

import rx.disposables.Composite;
import rx.Subscription;
import net.NetNode;
import util.Repeater;
import rx.ObservableFactory;
import rx.Observable;
import hxbit.NetworkSerializable;
import game.domain.overworld.location.Location;
import hxbit.NetworkHost;
import net.ClientController;
import util.Assert;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import game.net.entity.EntityReplicator;
import game.net.location.ChunkReplicator;
import game.net.location.CoreReplicator;
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
	A server-side only service, `PlayerReplicationManager` 
	manages singular player replication channel
**/
class PlayerReplicationManager {

	public static final PLAYER_VISION_RANGE_CHUNKS = 1;

	public final cliCon : ClientController;
	public final playerEntityReplicator : EntityReplicator;
	final playerEntity : OverworldEntity;
	final coreReplicator : CoreReplicator;

	/** chunks that are currently visible by a player **/
	final chunks : Map<Int, Map<Int, Map<Int, PlayerSubscribedChunk>>> = [];

	// final chunksSubscriptions:

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

		trace( "newing" );

		init();
	}

	function init() {
		playerEntity.chunk.addOnValueImmediately( onAddedToChunk );
		cliCon.addChild( playerEntityReplicator );
		cliCon.giveControlOverEntity( playerEntityReplicator );
		playerEntity.location.addOnValueImmediately( onAddedToLocation );

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

		giveControl();
	}

	function giveControl() {
		var transform = playerEntityReplicator.transformRepl;
		transform.x.syncBack = false;
		transform.y.syncBack = false;
		transform.z.syncBack = false;

		transform.velX.syncBack = false;
		transform.velY.syncBack = false;
		transform.velZ.syncBack = false;

		transform.rotationX.syncBack = false;
		transform.rotationY.syncBack = false;
		transform.rotationZ.syncBack = false;
	}

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
		for ( z in chunks ) {
			for ( y in z ) {
				for ( chunk in y ) {
					trace( "todo" );
					// cliCon.unregisterChild(
					// 	chunk,
					// 	NetworkHost.current
					// );
				}
			}
		}
		untyped chunks.length = 0;
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
						// xChunkRepl.replicator.chunk.onEntityRemoved.remove( onEntityRemovedFromChunk );
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

	function onEntityRemovedFromChunk( entity ) {
		if ( entity == playerEntity ) return;
		if ( !areChunksInRange(
			entity.chunk.getValue(),
			playerEntity.chunk.getValue(),
			PLAYER_VISION_RANGE_CHUNKS
		) ) {

			var entityReplicator = coreReplicator.getEntityReplicator( entity );
			entityReplicator.unregister(
				NetworkHost.current,
				cliCon.networkClient.ctx
			);
		}
	}

	function onAddedToChunk( oldChunk : Chunk, chunk : Chunk ) {
		if ( oldChunk.location != chunk.location ) {
			wipeAllChunks();
		} else {
			clearChunksOutOfRange( oldChunk, chunk );
		}

		attachVisibleChunks( chunk );
	}

	function onAddedToLocation( _, location : Location ) {
		if ( location == null ) return;

		var locationRepl = coreReplicator.getLocationReplicator( location );
		cliCon.onControlledEntityLocationChange( locationRepl );
	}
}
