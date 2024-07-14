package game.physics.oimo;

import game.core.rules.overworld.location.physics.ITransformProvider;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.ITransform;

class OimoRigidBodyTransformProvider implements ITransformProvider {

	final rigidBody : RigidBody;
	final transform : ITransform;

	public inline function new( rigidBody : RigidBody ) {
		this.rigidBody = rigidBody;
		this.transform = new OimoTransform( rigidBody._transform );
	}

	public inline function get() : ITransform {
		return transform;
	}
}
