package game.domain.overworld.entity.component;

import game.physics.oimo.ContactCallbackWrapper;
import oimo.dynamics.callback.ContactCallback;
import game.domain.overworld.location.Location;
import game.data.storage.DataStorage;
import game.physics.RigidBodyAbstractFactory;
import util.Const;
import game.physics.ShapeAbstractFactory;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.domain.overworld.location.physics.IRigidBody;

class EntityHitboxComponent extends EntityRigidBodyComponentBase {

	public final desc : HitboxBodyDescription;

	var torsoShape : IRigidBodyShape;

	public function new( desc : HitboxBodyDescription ) {
		super( desc );
		this.desc = desc;
	}

	function createRigidBody() {
		torsoShape = ShapeAbstractFactory.box(
			desc.sizeX,
			desc.sizeY,
			desc.sizeZ
		);
		torsoShape.setCollisionGroup( Const.G_HITBOX );
		torsoShape.setCollisionMask( 0 );

		var rigidBodyLocal = RigidBodyAbstractFactory.create( torsoShape, DYNAMIC );
		rigidBodyLocal.setRotationFactor( { x : 0, y : 0, z : 0 } );
		rigidBodyLocal.setLinearDamping( { x : 100, y : 100, z : 100 } );
		rigidBodyLocal.setGravityScale( 0 );

		torsoShape.moveLocally( 0, 0, desc.offsetZ - ( desc.sizeX / 2 ) % 1 );

		return rigidBodyLocal;
	}

	override function onAttachedToLocation( location : Location ) {
		super.onAttachedToLocation( location );

		entity.components.onAppear( EntityDynamicsComponent, onDynamicsAppeared );

		entity.transform.x.subscribeProp( rigidBody.x );
		entity.transform.y.subscribeProp( rigidBody.y );
		entity.transform.z.subscribeProp( rigidBody.z );
		// entity.transform.velX.subscribeProp( rigidBody.velX );
		// entity.transform.velY.subscribeProp( rigidBody.velY );
		// entity.transform.velZ.subscribeProp( rigidBody.velZ );
		// entity.transform.rotationX.subscribeProp( rigidBody.rotationX );
		// entity.transform.rotationY.subscribeProp( rigidBody.rotationY );
		// entity.transform.rotationZ.subscribeProp( rigidBody.rotationZ );
	}

	function onDynamicsAppeared( _, dynamics : EntityDynamicsComponent ) {
		dynamics.onMove.add(() -> rigidBody.wakeUp() );
	}
}
