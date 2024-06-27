package game.net.player;

import game.core.rules.overworld.location.Location;
import hxbit.NetworkHost;
import net.ClientController;
import util.Assert;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.location.Chunk;
import game.net.entity.EntityReplicator;
import game.net.location.ChunkReplicator;
import game.net.location.CoreReplicator;
import game.net.location.LocationReplicator;

/**
	`PlayerReplicationManager` manages singular player sight objects
**/
class PlayerReplicationManager {

	public static final PLAYER_VISION_RANGE_CHUNKS = 1;

	public final cliCon : ClientController;
	public final playerEntityReplicator : EntityReplicator;
	final playerEntity : OverworldEntity;
	final coreReplicator : CoreReplicator;

	final chunks : Map<Int, Map<Int, Map<Int, ChunkReplicator>>> = [];

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

		// playerChunksReplicationManager = new PlayerChunksReplicationManager();

		init();
	}

	function init() {
		playerEntity.chunk.addOnValueImmediately( onAddedToChunk );
		cliCon.addChild( playerEntityReplicator );
		cliCon.giveControlOverEntity( playerEntityReplicator );
		playerEntity.location.addOnValueImmediately( onAddedToLocation );
	}

	function validateChunkAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = new Map();
		if ( chunks[z][y] == null ) chunks[z][y] = new Map();
		if ( chunks[z][y][x] == null ) {
			var locationReplManager : LocationReplicator //
				= coreReplicator.getLocationReplicator( playerEntity.location.getValue() );
			chunks[z][y][x] = locationReplManager.getChunkReplicator( x, y, z );

			Assert.notNull( chunks[z][y][x], "chunk replicator is null" );
		}
	}

	#if !debug inline #end
	function isCoordsOutOfRange(
		x0 : Int,
		y0 : Int,
		z0 : Int,
		x1 : Int,
		y1 : Int,
		z1 : Int,
		range : Int
	) : Bool {
		return(
			Math.abs( x1 - x0 ) > range
			|| Math.abs( y1 - y0 ) > range
			|| Math.abs( z1 - z0 ) > range
		);
	}

	function wipeAllChunks() {
		for ( z in chunks ) {
			for ( y in z ) {
				for ( chunk in y ) {
					cliCon.unregisterChild(
						chunk,
						NetworkHost.current,
						cliCon.networkClient.ctx
					);
				}
			}
		}
		untyped chunks.length = 0;
	}

	function clearChunksOutOfRange( newChunk : Chunk ) {
		for ( zChunkRow in chunks ) {
			for ( yChunkRow in zChunkRow ) {
				for ( xi => xChunkRepl in yChunkRow ) {
					if ( isCoordsOutOfRange(
						newChunk.x,
						newChunk.y,
						newChunk.z,
						xChunkRepl.chunk.x,
						xChunkRepl.chunk.y,
						xChunkRepl.chunk.z,
						PLAYER_VISION_RANGE_CHUNKS
					) ) {
						yChunkRow.remove( xi );
						cliCon.unregisterChild(
							xChunkRepl,
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
		for ( z in newChunk.z - range...newChunk.z + range ) {
			for ( y in newChunk.y - range...newChunk.y + range ) {
				for ( x in newChunk.x - range...newChunk.x + range ) {
					validateChunkAccess( x, y, z );
					cliCon.addChild( chunks[z][y][x] );
				}
			}
		}
	}

	function onAddedToChunk( chunk : Chunk ) {
		var oldChunk = playerEntity.chunk.getValue();
		if ( oldChunk.location != chunk.location ) {
			wipeAllChunks();
		} else {
			clearChunksOutOfRange( chunk );
		}

		attachVisibleChunks( chunk );
	}

	function onAddedToLocation( location : Location ) {
		if ( location == null ) return;

		var locationRepl = coreReplicator.getLocationReplicator( location );
		cliCon.onControlledEntityLocationChange( locationRepl );
	}
}
