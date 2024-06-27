package game.physics.oimo;

import game.physics.oimo.OimoRigidBody;
import util.Assert;
import game.core.rules.overworld.location.physics.IRigidBody;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import oimo.dynamics.World;

class OimoPhysicsEngine implements IPhysicsEngine {

	var world = new World();

	public inline function new() {}

	public function update( dt : Float ) {
		world.step( dt );
	}

	public function addRigidBody( rigidBody : IRigidBody ) {
		Assert.isOfType( rigidBody, OimoRigidBody );
		world.addRigidBody( Std.downcast( rigidBody, OimoRigidBody ).rigidBody );
	}
}
