package game.domain.overworld.entity.component.ai.behaviours;

import dn.M;
import oimo.dynamics.callback.RayCastClosest;
import rx.disposables.Composite;
import util.GameUtil;
import util.MathUtil;
import game.data.storage.entity.body.properties.EntityAIDescription.AIProperties;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.physics.oimo.OimoWrappedShape;
import game.physics.oimo.RayCastCallback;

enum State {
	CALM;
	AGRO( enemy : OverworldEntity );
}

abstract class EntityBehaviourBase {

	static final ENEMY_CONTACT_RANGE = 6;
	static final MIN_COLLISION_EVADE_DISTANCE = 4;

	final agroRange : Float = 25;

	var dynamics : EntityDynamicsComponent;
	var model : EntityModelComponent;
	var attackComp : EntityAttackListComponent;
	var rigidBodyComp : EntityRigidBodyComponent;
	var entity( default, null ) : OverworldEntity;
	var state : State;

	var objectivePoint : ThreeDeeVector = new ThreeDeeVector();
	var pathfindCastCB = new RayCastCallback();

	public function new( params : AIProperties ) {
		state = CALM;
		if ( params?.agroRange != null ) agroRange = params.agroRange;
	}

	public function dispose( _ ) {}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
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
		entity.components.onAppear(
			EntityRigidBodyComponent,
			( cl, rigidBodyComp ) -> this.rigidBodyComp = rigidBodyComp
		);
		entity.location.onAppear( onAttachedToLocation );
		entity.disposed.then( dispose );
	}

	public function update( dt : Float, tmod : Float ) {
		if (
			model == null
			|| !model.isCapable() //
		) return;

		switch state {
			case CALM:
			case AGRO( enemy ):
				var offsetZ = enemy.desc.getBodyDescription().rigidBodyTorsoDesc?.offsetZ;
				if ( //
					M.dist(
						entity.transform.x,
						entity.transform.y,
						enemy.transform.x,
						enemy.transform.y
					) > ENEMY_CONTACT_RANGE //
				) {
					objectivePoint.set( enemy.transform.x, enemy.transform.y, enemy.transform.z.val + offsetZ );
					smartWalkToObjective( tmod );
				} else {
					dynamics.isMovementApplied.val = false;
				}

				attackComp.attack();
		}

		updateBehaviour( dt, tmod );
	}

	function updateBehaviour( dt : Float, tmod : Float ) {}

	function smartWalkToObjective( tmod : Float ) {
		if ( rigidBodyComp == null ) {
			walkTowardsPoint( objectivePoint.x, objectivePoint.y, tmod );
			return;
		}

		var shape = rigidBodyComp.rigidBody.getShape();
		var translation = objectivePoint.sub( entity.transform.getPosition() );
		var physics = entity.location.getValue().physics;
		var backward = entity.transform.getRotation().getForwardZ();
		backward.negate();
		var offsetDistance = 1.0;
		backward.scale( offsetDistance );
		var startTransform = rigidBodyComp.rigidBody.transform.clone();
		startTransform.add( backward );

		pathfindCastCB.clear();
		physics.convexCast(
			shape.getConfig().geom,
			startTransform,
			translation,
			pathfindCastCB
		);
		pathfindCastCB.sort();

		// raycast processing
		if ( !pathfindCastCB.hit ) {
			walkTowardsPoint( objectivePoint.x, objectivePoint.y, tmod );
			return;
		}

		// picking right shape contact
		var raycastHit : RayCastClosest = null;
		for ( contact in pathfindCastCB.contacts ) {
			if ( //
				contact.shape.getCollisionGroup() //
					& rigidBodyComp.rigidBody.getShape().getCollisionMask() == 0 //
			) continue;
			if ( //
				Std.downcast( contact.shape, OimoWrappedShape ) //
					== rigidBodyComp.rigidBody.getShape() //
			) continue;
			raycastHit = contact;
			break;
		}

		if ( raycastHit == null ) {
			walkTowardsPoint( objectivePoint.x, objectivePoint.y, tmod );
			return;
		}

		var distanceToCollision = translation.length() * raycastHit.fraction;
		var distanceToObjective = entity.transform.getPosition().distance( objectivePoint );

		#if client return; #end
		if ( distanceToCollision < MIN_COLLISION_EVADE_DISTANCE && distanceToObjective > ENEMY_CONTACT_RANGE ) {
			// obstacle bypassing
			// calculating direction to walk along the obstacle
			var direction = translation.normalized();
			raycastHit.normal.z = 0;
			raycastHit.normal.normalize();
			var tangent = direction.cross( raycastHit.normal );
			tangent.z = 0;
			tangent.normalize();
			if ( tangent.dot( direction ) < 0 ) {
				tangent.negate();
			}

			tangent.scale( model.stats.speed.amount.getValue() * tmod );
			entity.transform.velX.val += tangent.x;
			entity.transform.velY.val += tangent.y;
			dynamics.isMovementApplied.val = true;
			return;
		} else {
			// no need to bypass the obstacle: either too close to objective, or too far from obstacle
			walkTowardsPoint( objectivePoint.x, objectivePoint.y, tmod );
		}
	}

	function walkTowardsPoint( x : Float, y : Float, tmod : Float ) {
		#if client return; #end
		var angle = Math.atan2(
			y - entity.transform.y.val,
			x - entity.transform.x.val
		);
		var s = model.stats.speed.amount.getValue() * tmod;
		var inputDirX = Math.cos( angle ) * s;
		var inputDirY = Math.sin( angle ) * s;
		entity.transform.velX.val += inputDirX;
		entity.transform.velY.val += inputDirY;
		dynamics.isMovementApplied.val = true;
	}

	function onAttachedToLocation( location : Location ) {
		// location.behaviourManager.attachBehaviour( this, entity );
		// initializeAttackComponent();
	}

	final function sleep() {
		entity.components.get( EntityModelComponent )?.sleep();
	}

	final function wake() {
		entity.components.get( EntityModelComponent )?.wake();
	}

	inline function subscribeSurroundingChunksForEntityMovement( cb : OverworldEntity -> Void ) {
		var chunkChangedSub : Composite = null;
		entity.chunk.addOnValueImmediately( ( oldChunk, newChunk ) -> {
			chunkChangedSub?.unsubscribe();
			if ( newChunk == null ) return;
			chunkChangedSub = Composite.create();

			// var chunks = newChunk.location.chunks;
			// for ( tile in GameUtil.twoDGrid ) {
			// 	var x = tile.x + newChunk.x;
			// 	var y = tile.y + newChunk.y;
			// 	var z = newChunk.z;

			// 	chunkChangedSub.add( chunks.validateChunkAccess( x, y, z ).onEntityMoved.add( cb ) );
			// }
		} );
	}

	function initializeAttackComponent() {
		if ( attackComp == null ) return;
		if ( model.factions.length == 0 || !model.hasEnemy() ) return;

		subscribeSurroundingChunksForEntityMovement( onMaybeEnemyMoved );
	}

	inline function onMaybeEnemyMoved( maybeEnemy : OverworldEntity ) {
		if ( maybeEnemy == entity ) return;
		if ( !model.hasEnemy() ) return;
		var enemyModel = maybeEnemy.components.get( EntityModelComponent );
		if ( enemyModel == null || !model.isEnemy( maybeEnemy ) ) return;

		var dynamics = maybeEnemy.components.get( EntityDynamicsComponent );
		if ( dynamics == null ) return;

		onEnemyEntityMove( maybeEnemy );
	}

	function onEnemyEntityMove( enemy : OverworldEntity ) {
		if ( !model.isCapable() ) return;

		switch state {
			case AGRO( enemy ): return;
			default:
		}
		if ( entity.transform.distToEntity2D( enemy ) < agroRange ) {
			state = AGRO( enemy );
		}
	}

	// called when have no aggro in list and not sleeping
	function seekForEnemy() {
		#if client return null; #end
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
		// var entityChunk = entity.chunk.getValue();
		// var chunks = entity.location.getValue().chunks.chunks;

		// var entities : Array<OverworldEntity> = entity.chunk.getValue().entities;

		// for ( z in( entityChunk.z - 1 )...( entityChunk.z + 1 ) ) {
		// 	for ( y in( entityChunk.y - 1 )...( entityChunk.y + 1 ) ) {
		// 		for ( x in( entityChunk.x - 1 )...( entityChunk.x + 1 ) ) {
		// 			if ( z == 0 && y == 0 && x == 0 ) return;
		// 			entities = entities.concat( chunks[z][y][x].entities );
		// 		}
		// 	}
		// }

		// entities.sort( ( entity1, entity2 ) -> {
		// 	var dist1 = entity.transform.distToEntity2D( entity1 );
		// 	var dist2 = entity.transform.distToEntity2D( entity2 );
		// 	return Std.int( dist1 - dist2 );
		// } );

		// for ( entity in entities ) {
		// 	if ( entity == this.entity ) continue;
		// 	if ( !fn( entity ) )
		// 		break;
		// }
	}
}
