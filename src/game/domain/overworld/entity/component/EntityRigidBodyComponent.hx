package game.domain.overworld.entity.component;

import oimo.dynamics.rigidbody.MassData;
import be.Constant.Ints;
import rx.disposables.ISubscription;
import game.data.location.objects.LocationCollisionObjectVO;
import rx.disposables.Composite;
import dn.M;
import dn.phys.Velocity;
import game.physics.oimo.EntityRigidBodyProps;
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

	static final rotationApplicationVelMin = 4;

	final rigidBodyDesc : RigidBodyTorsoDescription;

	public var torsoShape( default, null ) : IRigidBodyShape;
	var standRayCastCallback : RayCastCallback;
	var dynamicsComponent : EntityDynamicsComponent;

	public function new( description : RigidBodyTorsoDescription ) {
		super( description );
		this.rigidBodyDesc = description;
	}

	override public function claimOwnage() {
		super.claimOwnage();
		rigidBodyFuture.then( rigidBody -> {
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

			var maybeSub = entity.components.onAppear( EntityDynamicsComponent, onDynamicsAppeared );
			if ( maybeSub != null ) subscription.add( maybeSub );

			var intertia = torsoShape.getConfig().geom.getIntertiaCoeff();
			var massData = new MassData();
			massData.localInertia = intertia;
			massData.mass = 1;
			rigidBody.setMassData( massData );
		} );
	}

	public function provideExtraShapes( objs : Array<LocationCollisionObjectVO> ) {
		rigidBodyFuture.then( ( rb ) -> {
			for ( obj in objs ) {
				var shape = switch obj.geometry {
					case BOX:
						ShapeAbstractFactory.box(
							obj.sizeX,
							obj.sizeY,
							obj.sizeZ
						);
				}
				shape.moveLocally( obj.x, obj.y, obj.z );
				shape.setCollisionGroup( Const.G_PHYSICS );
				shape.setCollisionMask( Const.G_PHYSICS );
				rb.addShape( shape );
			}
		} );
	}

	function createRigidBody() {
		torsoShape = switch rigidBodyDesc.geometry {
			case BOX:
				ShapeAbstractFactory.box(
					rigidBodyDesc.sizeX,
					rigidBodyDesc.sizeY,
					rigidBodyDesc.sizeZ
				);
			case CAPSULE:
				ShapeAbstractFactory.capsule(
					rigidBodyDesc.sizeX,
					rigidBodyDesc.sizeZ
				);
		}
		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );
		torsoShape.moveLocally( rigidBodyDesc.offsetX, rigidBodyDesc.offsetY, rigidBodyDesc.offsetZ );
		torsoShape.setFriction( 0 );
		var intertia = torsoShape.getConfig().geom.getIntertiaCoeff();

		var rigidBodyLocal = RigidBodyAbstractFactory.create(
			torsoShape,
			rigidBodyDesc.isStatic ? STATIC : DYNAMIC,
			new EntityRigidBodyProps( entity )
		);

		rigidBodyLocal.setRotationFactor( { x : 0, y : 0, z : 0 } );
		rigidBodyLocal.setLinearDamping( { x : 10, y : 10, z : 9999 } );
		rigidBodyLocal.setGravityScale( DataStorage.inst.rule.entityGravityScale );

		rigidBodyLocal.wakeUp();

		var massData = new MassData();
		massData.localInertia = intertia;
		massData.mass = 9999;
		rigidBodyLocal.setMassData( massData );

		entity.transform.x.subscribeProp( rigidBodyLocal.x, true );
		entity.transform.y.subscribeProp( rigidBodyLocal.y, true );
		entity.transform.z.subscribeProp( rigidBodyLocal.z, true );
		entity.transform.velX.subscribeProp( rigidBodyLocal.velX, true );
		entity.transform.velY.subscribeProp( rigidBodyLocal.velY, true );
		entity.transform.velZ.subscribeProp( rigidBodyLocal.velZ, true );
		entity.transform.rotationX.subscribeProp( rigidBodyLocal.rotationX, true );
		entity.transform.rotationY.subscribeProp( rigidBodyLocal.rotationY, true );
		entity.transform.rotationZ.subscribeProp( rigidBodyLocal.rotationZ, true );

		return rigidBodyLocal;
	}

	function onDynamicsAppeared( key, dynamicsComponent : EntityDynamicsComponent ) {
		standRayCastCallback = new RayCastCallback();
		standRayCastCallback.onShapeCollide.add( onRayCollide );

		this.dynamicsComponent = dynamicsComponent;

		dynamicsComponent.onMove.add(() -> {
			rigidBody.wakeUp();
			if (
				Math.abs( rigidBody.velX.val ) > rotationApplicationVelMin
				|| Math.abs( rigidBody.velY.val ) > rotationApplicationVelMin
			) {
				setRotationBasedOffVelocities();
			}
		} );

		if ( rigidBodyDesc.hasFeet ) {
			dynamicsComponent.onMove.add(() -> {
				var start = torsoShape.getPosition();
				var end = start.clone();
				end.z -= rigidBodyDesc.offsetZ;

				physics.rayCast( start, end, standRayCastCallback );
				standRayCastCallback.clear();
			} );
		}

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

		rigidBody.move( 0, 0, ( 1 - rayCastHit.fraction ) * rigidBodyDesc.offsetZ );

		rigidBody.velZ.val = 0;
		if ( rigidBody.velX.val == 0 && rigidBody.velY.val == 0 ) {
			rigidBody.sleep();
		}
	}
}
