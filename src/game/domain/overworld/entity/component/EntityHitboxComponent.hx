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
		rigidBodyLocal.setLinearDamping( { x : 100, y : 100, z : 100 } );
		rigidBodyLocal.setGravityScale( 0 );

		return rigidBodyLocal;
	}

	override function onAttachedToLocation( location : Location ) {
		super.onAttachedToLocation( location );

		var maybeSub = entity.components.onAppear( EntityDynamicsComponent, onDynamicsAppeared );
		if ( maybeSub != null ) subscription.add( maybeSub );

		subscription.add( entity.transform.x.subscribeProp( rigidBody.x ) );
		subscription.add( entity.transform.y.subscribeProp( rigidBody.y ) );
		subscription.add( entity.transform.z.subscribeProp( rigidBody.z ) );
	}

	function onDynamicsAppeared( _, dynamics : EntityDynamicsComponent ) {
		subscription.add( dynamics.onMove.add(() -> rigidBody.wakeUp() ) );
	}
}
