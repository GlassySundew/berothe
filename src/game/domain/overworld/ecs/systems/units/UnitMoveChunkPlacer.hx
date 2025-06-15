package game.domain.overworld.ecs.systems.units;

import echoes.Entity;
import echoes.System;
import game.domain.overworld.ecs.components.units.UnitDynamics.MovedThisTick;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitChunk;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitPlacedInChunkEvent;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitPosition;
import game.domain.overworld.location.physics.Types.IntVec;

/**
	перемещает сущность юнита в новый чанк если она переместилась
**/
@:priority( SystemPriority.CORE )
class UnitMoveChunkPlacer extends System {

	final context : IOverworldContext;

	public function new( world, ?priority ) {

		super( world, priority );

		context = world.getService( IOverworldContext );
	}

	@:upd
	function update(
		position : UnitPosition,
		__move : MovedThisTick,
		entity : Entity
	) : Void {

		final newChunkPos = getChunkPos( position );

		if ( hasComponent( entity, ( _ : UnitChunk ) ) ) {
			final chunkPos = getComponent( entity, UnitChunk );

			if ( areChunksEqual( newChunkPos, chunkPos ) )
				return;

			removeEntityFromChunk( entity );
		} else {
			addComponent( entity, ( { x : 0, y : 0, z : 0 } : UnitChunk ) );
		}

		placeEntityToChunk( newChunkPos, entity );
		addComponent( entity, ({} : UnitPlacedInChunkEvent ) );
	}

	function removeEntityFromChunk( entity : Entity ) {
		final oldChunk = getComponent( entity, UnitChunk );
		context.chunks.getChunk(
			oldChunk.x,
			oldChunk.y,
			oldChunk.z
		).removeEntity( entity );
	}

	function placeEntityToChunk( newChunkPos : IntVec, entity : Entity ) {
		context.chunks.getChunk(
			newChunkPos.x,
			newChunkPos.y,
			newChunkPos.z
		).addEntity( entity );
	}

	function areChunksEqual( chunk1Pos : IntVec, chunk2 : UnitChunk ) : Bool {

		return
			chunk1Pos.x == chunk2.x
			&& chunk1Pos.y == chunk2.y
			&& chunk1Pos.z == chunk2.z;
	}

	function getChunkPos( pos : UnitPosition ) : IntVec {

		final size = context.chunks.chunkSize;
		return {
			x : Std.int( pos.x / size ),
			y : Std.int( pos.y / size ),
			z : Std.int( pos.z / size )
		};
	}
}
