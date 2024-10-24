package game.domain.overworld.location;

import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.physics.Types;

class Chunks {

	final chunkSize : Int;
	final location : Location;
	public final chunks : Map<Int, Map<Int, Map<Int, Chunk>>> = [];

	public function new( location : Location, chunkSize : Int ) {
		this.chunkSize = chunkSize;
		this.location = location;
	}

	public function removeEntity( entity : OverworldEntity ) {
		var chunkIdx = getChunkIdxFromAbsolute( {
			x : entity.transform.x.val,
			y : entity.transform.y.val,
			z : entity.transform.z.val
		} );

		var chunk = validateChunkAccess(
			Std.int( chunkIdx.x ),
			Std.int( chunkIdx.y ),
			Std.int( chunkIdx.z )
		);
		#if client
		if ( !chunk.entities.contains( entity ) ) return;
		#end

		chunk.removeEntity( entity );
	}

	public function addEntity( entity : OverworldEntity ) {
		entity.components.get( EntityDynamicsComponent )?.onMove.add( onEntityMove.bind( entity ) );
		onEntityMove( entity );
	}

	public function validateChunkAccess( x : Int, y : Int, z : Int ) {
		if ( chunks[z] == null ) chunks[z] = new Map();
		if ( chunks[z][y] == null ) chunks[z][y] = new Map();
		if ( chunks[z][y][x] == null ) {
			var chunk : Chunk = chunks[z][y][x] = new Chunk( x, y, z, chunkSize, location );
			location.onChunkCreated.dispatch( chunk );
		}
		return chunks[z][y][x];
	}

	function onEntityMove( entity : OverworldEntity ) {
		var chunkIdx = getChunkIdxFromAbsolute( {
			x : entity.transform.x.val,
			y : entity.transform.y.val,
			z : entity.transform.z.val
		} );

		var currentChunk = validateChunkAccess(
			Std.int( chunkIdx.x ),
			Std.int( chunkIdx.y ),
			Std.int( chunkIdx.z )
		);

		if ( entity.chunk.getValue() != currentChunk ) {
			currentChunk.addEntity( entity );
		}
	}

	inline function getChunkIdxFromAbsolute( coords : ThreeDeeVector ) : ThreeDeeVector {
		return new ThreeDeeVector(
			Math.floor( coords.x / chunkSize ),
			Math.floor( coords.y / chunkSize ),
			Math.floor( coords.z / chunkSize )
		);
	}
}
