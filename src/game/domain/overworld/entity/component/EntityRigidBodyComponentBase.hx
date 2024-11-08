package game.domain.overworld.entity.component;

import rx.disposables.Composite;
import future.Future;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.domain.overworld.location.physics.IRigidBody;

abstract class EntityRigidBodyComponentBase extends EntityPhysicsComponentBase {

	public var rigidBodyFuture( default, null ) : Future<IRigidBody> = new Future();
	public var rigidBody( default, null ) : IRigidBody;

	var subscribition : Composite;

	public override function dispose() {
		super.dispose();
		detach();
	}

	override function onAttachedToLocation( location : Location ) {
		if ( rigidBody != null ) {
			detach();
			subscribition.unsubscribe();
			rigidBodyFuture = new Future();
		}
		subscribition = Composite.create();

		super.onAttachedToLocation( location );

		rigidBody = tryCreateRigidBody();
		rigidBody.setPosition( { x : entity.transform.x, y : entity.transform.y, z : entity.transform.z } );
		physics.addRigidBody( rigidBody );

		rigidBodyFuture.resolve( rigidBody );
	}

	function detach() {
		physics?.removeRigidBody( rigidBody );
		rigidBody = null;
		physics = null;
	}

	final function tryCreateRigidBody() {
		if ( rigidBody != null )
			throw "bad logic, rigidBody is not suppposed to be created twice for one component, entity: " + entity;

		return createRigidBody();
	}

	abstract function createRigidBody() : IRigidBody;
}
