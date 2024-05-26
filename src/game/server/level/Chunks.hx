package game.server.level;

import dn.M;
import en.Entity;
import en.player.PlayerChannelContainer;
import game.server.level.block.Block;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.Server;
import util.Const;

/**
	per-level
**/
class Chunks {

	var chunks : Map<Int, Map<Int, Chunk>> = [];
	var level : ServerLevelController;

	public function new( level : ServerLevelController ) {
		this.level = level;
	}

	public inline function get( x : Int, y : Int ) : Chunk {
		if ( chunks[y] == null ) chunks[y] = new Map();
		if ( chunks[y][x] == null ) {
			var chunk = new Chunk();
			chunk.x = x;
			chunk.y = y;
			chunks[y][x] = chunk;
		}
		return chunks[y][x];
	}

	public inline function placeBlock( x : Int, y : Int, z : Int, block : Block ) {
		var chunkX = M.floor( x / level.cdb.chunkSize );
		var chunkY = M.floor( y / level.cdb.chunkSize );

		get( chunkX, chunkY ).setBlock( x, y, z, block );
	}

	public function attachWatcherEntity(
		entity : Entity,
		ctx : NetworkSerializer,
		chunksHolder : PlayerChannelContainer
	) {
		// entity.onMove.add(() -> {
		// 	placeEntity( entity, chunksHolder );
		// } );

		// entity.model.chunk.addOnValue( ( chunk : Chunk ) -> {
		// 	loadVisibleChunks( entity, chunk, ctx, chunksHolder );
		// } );
	}

	public function placeEntity(
		entity : Entity,
		?chunksHolder : PlayerChannelContainer
	) {
		var entityChunk = entity.model.chunk;
		var entityNewChunkX = M.floor(
			entity.x.val / level.cdb.chunkSize
		);
		var entityNewChunkY = M.floor(
			entity.y.val / level.cdb.chunkSize
		);
		if (
			entityChunk.val == null ||
			entityNewChunkX != entityChunk.val.x ||
			entityNewChunkY != entityChunk.val.y
		) {
			var newChunk = get( entityNewChunkX, entityNewChunkY );
			entity.model.chunk.val = newChunk;
			if ( chunksHolder != null ) {
				chunksHolder.setChunk(
					entityNewChunkX,
					entityNewChunkY,
					entity.model.chunk
				);
			}
		}
	}

	public function loadVisibleChunks(
		entity : Entity,
		newChunk : Chunk,
		ctx : NetworkSerializer,
		chunksHolder : PlayerChannelContainer
	) @:privateAccess {
		var r = Const.chunkVisionRadius;

		if ( entity.model.chunk.val != null ) {
			// removing invisible chunks
			var oldChunk = entity.model.chunk.val;
			var deltaX = oldChunk.x - newChunk.x;
			var deltaY = oldChunk.y - newChunk.y;

			if ( deltaX < 0 ) {
				for ( y in ( oldChunk.y - r ) ... ( oldChunk.y + r ) )
					for ( x in ( oldChunk.x - r ) ... ( newChunk.x - r ) ) {
						if ( chunksHolder.hasChunkAt( x, y ) ) {
							chunksHolder.removeChunk( x, y );
							get( x, y ).unregister( Server.inst.host, ctx );
						}
					}
			} else {
				for ( y in ( oldChunk.y - r ) ... ( oldChunk.y + r ) )
					for ( x in ( newChunk.x + r ) ... ( oldChunk.x + r ) ) {
						if ( chunksHolder.hasChunkAt( x, y ) ) {
							chunksHolder.removeChunk( x, y );
							get( x, y ).unregister( Server.inst.host, ctx );
						}
					}
			}

			if ( deltaY < 0 ) {
				for ( y in ( oldChunk.y - r ) ... ( newChunk.y - r ) )
					for ( x in ( oldChunk.x - r ) ... ( oldChunk.x + r ) ) {
						if ( chunksHolder.hasChunkAt( x, y ) ) {
							chunksHolder.removeChunk( x, y );
							get( x, y ).unregister( Server.inst.host, ctx );
						} else {
							trace( "trying to remove unexsisting chunk" );
						}
					}
			} else {
				for ( y in ( newChunk.y + r ) ... ( oldChunk.y + r ) )
					for ( x in ( oldChunk.x - r ) ... ( oldChunk.x + r ) ) {
						if ( chunksHolder.hasChunkAt( x, y ) ) {
							chunksHolder.removeChunk( x, y );
							get( x, y ).unregister( Server.inst.host, ctx );
						}
					}
			}

			for ( chunkY in chunksHolder.chunks.map ) {
				for ( chunk in ( chunkY.map.map : Map<Int, Chunk> ) ) {}
			}
		}

		for ( y in newChunk.y - r ... newChunk.y + r ) {
			for ( x in newChunk.x - r ... newChunk.x + r ) {
				var chunk = get( x, y );
				chunksHolder.setChunk( x, y, chunk );
			}
		}
	}
}
