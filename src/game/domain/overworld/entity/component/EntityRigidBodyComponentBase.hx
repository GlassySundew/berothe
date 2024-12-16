package game.domain.overworld.entity.component;

import rx.disposables.Composite;
import future.Future;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.domain.overworld.location.physics.IRigidBody;

abstract class EntityRigidBodyComponentBase extends EntityPhysicsComponentBase {

	public var rigidBodyFuture( default, null ) : Future<IRigidBody> = new Future();
	public var rigidBody( default, null ) : IRigidBody;

	var subscription : Composite;

	public override function dispose() {
		super.dispose();
		subscription?.unsubscribe();
		detach();
	}

	override function onAttachedToLocation( oldLoc : Location, location : Location ) {
		subscription?.unsubscribe();
		if ( rigidBody != null ) {
			detach();
		}

		if ( location == null ) return;

		subscription = Composite.create();

		super.onAttachedToLocation( oldLoc, location );

		if ( rigidBody == null ) {
			rigidBody = tryCreateRigidBody();
			rigidBodyFuture.resolve( rigidBody );
		}
		rigidBody.setPosition( { x : entity.transform.x, y : entity.transform.y, z : entity.transform.z } );
		physics.addRigidBody( rigidBody );
	}

	function detach() {
		physics?.removeRigidBody( rigidBody );
		physics = null;
	}

	final function tryCreateRigidBody() {
		if ( rigidBody != null )
			throw "bad logic, rigidBody is not suppposed to be created twice for one component, entity: " + entity;

		return createRigidBody();
	}

	abstract function createRigidBody() : IRigidBody;
}
