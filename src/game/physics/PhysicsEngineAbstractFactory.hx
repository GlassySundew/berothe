package game.physics;

import game.physics.oimo.OimoPhysicsEngine;
import game.core.rules.overworld.location.physics.IPhysicsEngine;

class PhysicsEngineAbstractFactory {

	public static function create() : IPhysicsEngine {
		return new OimoPhysicsEngine();
	}
}
