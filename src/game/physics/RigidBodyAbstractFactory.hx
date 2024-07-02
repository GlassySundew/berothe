package game.physics;

import game.core.rules.overworld.location.physics.Types.RigidBodyType;
import util.Assert;
import game.physics.oimo.OimoRigidBody;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import game.core.rules.overworld.location.physics.IRigidBody;

class RigidBodyAbstractFactory {

	public static function create( shape : IRigidBodyShape, type : RigidBodyType ) : IRigidBody {
		return new OimoRigidBody( shape, type );
	}
}
