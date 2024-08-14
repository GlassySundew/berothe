package game.domain.overworld.entity.component;

import future.Future;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.domain.overworld.location.physics.IRigidBody;

abstract class EntityRigidBodyComponentBase extends EntityPhysicsComponentBase {

	public final rigidBodyFuture : Future<IRigidBody> = new Future();
	public var rigidBody(default, null) : IRigidBody;

	override function onAttachedToLocation( location : Location ) {
		super.onAttachedToLocation( location );

		rigidBody = tryCreateRigidBody();
		rigidBody.setPosition( { x : entity.transform.x, y : entity.transform.y, z : entity.transform.z } );
		physics.addRigidBody( rigidBody );
		
		rigidBodyFuture.resolve( rigidBody );
	}

	final function tryCreateRigidBody() {
		if ( rigidBody != null )
			throw "bad logic, rigidBody is not suppposed to be created twice for one component";

		return createRigidBody();
	}

	abstract function createRigidBody() : IRigidBody;
}
