package game.physics;

import game.domain.overworld.location.physics.Types.RigidBodyType;
import util.Assert;
import game.physics.oimo.OimoRigidBody;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.Shape;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.IRigidBody;

class RigidBodyAbstractFactory {

	public static function create(
		shape : IRigidBodyShape,
		type : RigidBodyType,
		?props : Any
	) : IRigidBody {
		return OimoRigidBody.create( shape, type, props );
	}
}
