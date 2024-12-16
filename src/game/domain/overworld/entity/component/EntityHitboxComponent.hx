package game.domain.overworld.entity.component;

import rx.disposables.Composite;
import game.physics.oimo.EntityRigidBodyProps;
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
		torsoShape.setCollisionMask( Const.G_HITBOX );
		torsoShape.moveLocally( desc.offsetX, desc.offsetY, desc.offsetZ );

		var rigidBodyLocal = RigidBodyAbstractFactory.create(
			torsoShape,
			TRIGGER,
			new EntityRigidBodyProps( entity )
		);
		rigidBodyLocal.setRotationFactor( { x : 0, y : 0, z : 0 } );
		rigidBodyLocal.setLinearDamping( { x : 99999, y : 99999, z : 99999 } );
		rigidBodyLocal.setGravityScale( 0 );

		entity.components.onAppear( EntityDynamicsComponent, onDynamicsAppeared );

		entity.transform.x.subscribeProp( rigidBodyLocal.x );
		entity.transform.y.subscribeProp( rigidBodyLocal.y );
		entity.transform.z.subscribeProp( rigidBodyLocal.z );

		return rigidBodyLocal;
	}

	function onDynamicsAppeared( _, dynamics : EntityDynamicsComponent ) {
		dynamics.onMove.add(() -> rigidBody.wakeUp() );
	}
}
