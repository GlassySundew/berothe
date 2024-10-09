package game.domain.overworld.entity.component;

import oimo.common.Vec3;
import game.physics.oimo.ContactCallbackWrapper;
import game.physics.oimo.RayCastCallback;
import util.Const;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.RayCastHit;
import game.data.storage.DataStorage;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.physics.RigidBodyAbstractFactory;
import game.physics.ShapeAbstractFactory;
import game.physics.oimo.OimoRigidBody;

class EntityRigidBodyComponent extends EntityRigidBodyComponentBase {

	public var isOwned( default, null ) : Bool = false;

	final rigidBodyDesc : RigidBodyTorsoDescription;

	var torsoShape : IRigidBodyShape;
	var standRayCastCallback : RayCastCallback;
	var dynamicsComponent : EntityDynamicsComponent;

	public function new( description : RigidBodyTorsoDescription ) {
		super( description );
		this.rigidBodyDesc = description;
	}

	override public function claimOwnage() {
		entity.location.onAppear( loc -> {
			rigidBodyFuture.then( rigidBody -> {
				isOwned = true;

				rigidBody.setGravityScale( DataStorage.inst.rule.entityGravityScale );
				rigidBody.setLinearDamping( { x : 25, y : 25, z : 0 } );

				rigidBody.x.subscribeProp( entity.transform.x );
				rigidBody.y.subscribeProp( entity.transform.y );
				rigidBody.z.subscribeProp( entity.transform.z );
				rigidBody.velX.subscribeProp( entity.transform.velX );
				rigidBody.velY.subscribeProp( entity.transform.velY );
				rigidBody.velZ.subscribeProp( entity.transform.velZ );
				rigidBody.rotationX.subscribeProp( entity.transform.rotationX );
				rigidBody.rotationY.subscribeProp( entity.transform.rotationY );
				rigidBody.rotationZ.subscribeProp( entity.transform.rotationZ );
			} );
		} );
	}

	override function onAttachedToLocation( location : Location ) {
		super.onAttachedToLocation( location );

		if ( rigidBodyDesc.hasFeet ) {
			entity.components.onAppear( EntityDynamicsComponent, subscribeStanding );
		}

		entity.transform.x.subscribeProp( rigidBody.x, true );
		entity.transform.y.subscribeProp( rigidBody.y, true );
		entity.transform.z.subscribeProp( rigidBody.z, true );
		entity.transform.velX.subscribeProp( rigidBody.velX, true );
		entity.transform.velY.subscribeProp( rigidBody.velY, true );
		entity.transform.velZ.subscribeProp( rigidBody.velZ, true );
		entity.transform.rotationX.subscribeProp( rigidBody.rotationX, true );
		entity.transform.rotationY.subscribeProp( rigidBody.rotationY, true );
		entity.transform.rotationZ.subscribeProp( rigidBody.rotationZ, true );
	}

	function createRigidBody() {
		torsoShape = ShapeAbstractFactory.box(
			rigidBodyDesc.sizeX,
			rigidBodyDesc.sizeY,
			rigidBodyDesc.sizeZ
		);
		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );

		var rigidBodyLocal = RigidBodyAbstractFactory.create( torsoShape, DYNAMIC );
		rigidBodyLocal.setRotationFactor( { x : 0, y : 0, z : 0 } );
		rigidBodyLocal.setLinearDamping( { x : 9999, y : 9999, z : 9999 } );

		rigidBodyLocal.setGravityScale( 0 );

		torsoShape.moveLocally( rigidBodyDesc.offsetX, rigidBodyDesc.offsetY, rigidBodyDesc.offsetZ  );

		return rigidBodyLocal;
	}

	function subscribeStanding( key, dynamicsComponent : EntityDynamicsComponent ) {
		standRayCastCallback = new RayCastCallback();
		standRayCastCallback.onShapeCollide.add( onRayCollide );

		this.dynamicsComponent = dynamicsComponent;

		dynamicsComponent.onMove.add(() -> {
			rigidBody.wakeUp();
			setRotationBasedOffVelocities();

			var start = torsoShape.getPosition();
			var end = start.clone();
			end.z -= rigidBodyDesc.offsetZ;

			physics.rayCast( start, end, standRayCastCallback );
		} );

		dynamicsComponent.invalidateMove();
	}

	inline function setRotationBasedOffVelocities() {
		if (
			!dynamicsComponent.isMovementApplied.val
			|| dynamicsComponent.isResting.val
		) return;

		var angle = Math.atan2( entity.transform.velY.val, entity.transform.velX.val );
		rigidBody.setRotation( 0, 0, angle );
	}

	function onRayCollide( shape : IRigidBodyShape, rayCastHit : RayCastHit ) {
		if ( shape.getCollisionGroup() & torsoShape.getCollisionMask() == 0 ) return;

		rigidBody.move( 0, 0, ( 1 - rayCastHit.fraction ) * rigidBodyDesc.offsetZ  );

		rigidBody.velZ.val = 0;
		if ( rigidBody.velX.val == 0 && rigidBody.velY.val == 0 ) {
			rigidBody.sleep();
		}
	}
}
