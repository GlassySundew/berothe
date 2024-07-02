package game.core.rules.overworld.entity.component;

import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import game.core.rules.overworld.location.physics.IRigidBody;

abstract class EntityPhysicalComponentBase extends EntityComponent {

	var physics : IPhysicsEngine;
	var rigidBody : IRigidBody;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		physics = location.physics;
		rigidBody = tryCreateRigidBody();

		rigidBody.setPosition( { x : entity.transform.x, y : entity.transform.y, z : entity.transform.z } );
		physics.addRigidBody( rigidBody );
	}

	final function tryCreateRigidBody() {
		if ( rigidBody != null )
			throw "bad logic, rigidBody is not suppposed to be created twice for one component";

		return createRigidBody();
	}

	abstract function createRigidBody() : IRigidBody;
}
