package game.physics.oimo;

import oimo.common.Vec3;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVectorType;
import game.core.rules.overworld.location.physics.Types.RigidBodyType;
import util.Assert;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.IRigidBody;

class OimoRigidBody implements IRigidBody {

	public final rigidBody : RigidBody;

	var initialShape : Shape;

	public inline function new( shape : IRigidBodyShape, type : RigidBodyType ) {
		Assert.isOfType( shape, OimoRigidBodyShape );
		var unwrapShape = Std.downcast( shape, OimoRigidBodyShape ).shape;

		var config = new RigidBodyConfig();
		config.type = switch type {
			case DYNAMIC: oimo.dynamics.rigidbody.RigidBodyType.DYNAMIC;
			case STATIC: oimo.dynamics.rigidbody.RigidBodyType.STATIC;
			case KINEMATIC: oimo.dynamics.rigidbody.RigidBodyType.KINEMATIC;
		}

		rigidBody = new RigidBody( config );
		rigidBody.addShape( unwrapShape );
	}

	public inline function addShape( shape : IRigidBodyShape ) {
		rigidBody.addShape( Std.downcast( shape, OimoRigidBodyShape ).shape );
	}

	public inline function setRotationFactor( rotationFactor : ThreeDeeVectorType ) {
		rigidBody.setRotationFactor(
			new Vec3(
				rotationFactor.x,
				rotationFactor.y,
				rotationFactor.z
			) );
	}

	public inline function setLinearDamping( damping : ThreeDeeVectorType ) {
		rigidBody.setLinearDamping(
			new Vec3(
				damping.x,
				damping.y,
				damping.z
			)
		);
	}

	public inline function setGravityScale( gravitiScale : Float ) {
		rigidBody.setGravityScale( gravitiScale );
	}

	public function setPosition( pos : ThreeDeeVectorType ) {
		rigidBody.setPosition( new Vec3( pos.x, pos.y, pos.z ) );
	}
}
