package game.domain.overworld.entity.component.ai.behaviours;

import dn.M;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Location;
import util.MathUtil;
import game.domain.overworld.location.Chunk;
import game.domain.overworld.entity.component.model.EntityModelComponent;

enum State {
	CALM;
	AGRO( enemy : OverworldEntity );
}

abstract class EntityBehaviourBase {

	static final enemyContactRange = 5;

	var dynamics : EntityDynamicsComponent;
	var model : EntityModelComponent;
	var attackComp : EntityAttackListComponent;
	var entity( default, null ) : OverworldEntity;
	var state : State;

	public function new() {
		state = CALM;
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.location.onAppear( onAttachedToLocation );
		entity.components.onAppear(
			EntityDynamicsComponent,
			( cl, dynComp ) -> this.dynamics = dynComp
		);
		entity.components.onAppear(
			EntityModelComponent,
			( cl, model ) -> this.model = model
		);
		entity.components.onAppear(
			EntityAttackListComponent,
			( cl, attackComp ) -> this.attackComp = attackComp
		);
	}

	public function update( dt : Float, tmod : Float ) {
		switch state {
			case CALM:
			case AGRO( enemy ):
				// find angle to enemy
				if ( //
					M.dist(
						entity.transform.x,
						entity.transform.y,
						enemy.transform.x,
						enemy.transform.y
					) > enemyContactRange //
				) {

					var angle = Math.atan2(
						enemy.transform.y.val - entity.transform.y.val,
						enemy.transform.x.val - entity.transform.x.val
					);
					var s = model.speed.amount.getValue() * tmod;
					var inputDirX = Math.cos( angle ) * s;
					var inputDirY = Math.sin( angle ) * s;
					entity.transform.velX.val += inputDirX;
					entity.transform.velY.val += inputDirY;
					dynamics.isMovementApplied.val = true;
				}

				attackComp.attack();
		}
	}

	function onAttachedToLocation( location : Location ) {
		location.behaviourManager.attachBehaviour( this );
	}

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
			if ( enemy == entity ) {
				trace( "found same entity, " + enemy );
				return true;
			}
			if ( entity.components.get( EntityModelComponent ).isEnemy( enemy ) ) {
				enemyEntity = enemy;
				return false;
			}
			return true;
		} );
		return enemyEntity;
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
