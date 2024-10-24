package game.domain.overworld.entity.component.ai.behaviours;

import game.domain.overworld.location.Location;
import util.MathUtil;
import game.domain.overworld.location.Chunk;
import game.domain.overworld.entity.component.model.EntityModelComponent;

enum State {
	CALM;
	AGRO;
}

abstract class EntityBehaviourBase {

	var entity( default, null ) : OverworldEntity;

	public function new() {}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.location.onAppear( onAttachedToLocation );
	}

	public function update() {}

	function onAttachedToLocation( location : Location ) {}

	final function sleep() {
		entity.components.get( EntityModelComponent ).sleep();
	}

	final function wake() {
		entity.components.get( EntityModelComponent ).wake();
	}

	// called when have no aggro in list and not sleeping
	function seekForEnemy() {
		var enemyEntity = null;
		mapSurroundingEntities( ( enemy ) -> {
			if ( enemy == entity ) return true;
			if ( entity.components.get( EntityModelComponent ).isEnemy( enemy ) ) {
				enemyEntity = entity;
				return false;
			}
			return true;
		} );
	}

	function mapSurroundingEntities( fn : ( entity : OverworldEntity ) -> Bool ) {
		var entityChunk = entity.chunk.getValue();
		var chunks = entity.location.getValue().chunks.chunks;

		var entities : Array<OverworldEntity> = entity.chunk.getValue().entities;

		for ( z in( entityChunk.z - 1 )...( entityChunk.z + 1 ) ) {
			for ( y in( entityChunk.y - 1 )...( entityChunk.y + 1 ) ) {
				for ( x in( entityChunk.x - 1 )...( entityChunk.x + 1 ) ) {
					if ( z == 0 && y == 0 && x == 0 ) return;
					entities = entities.concat( chunks[z][y][x].entities );
				}
			}
		}

		entities.sort( ( entity1, entity2 ) -> {
			var dist1 = MathUtil.dist3(
				entity1.transform.x,
				entity1.transform.y,
				entity1.transform.z,
				entity.transform.x,
				entity.transform.y,
				entity.transform.z,
			);
			var dist2 = MathUtil.dist3(
				entity2.transform.x,
				entity2.transform.y,
				entity2.transform.z,
				entity.transform.x,
				entity.transform.y,
				entity.transform.z,
			);
			return Std.int( dist1 - dist2 );
		} );

		for ( entity in entities ) {
			if ( entity == this.entity ) continue;
			if ( !fn( entity ) )
				break;
		}
	}
}
