package game.physics;

import game.physics.oimo.OimoPhysicsEngine;
import game.domain.overworld.location.physics.IPhysicsEngine;

class PhysicsEngineAbstractFactory {

	public static function create() : IPhysicsEngine {
		return new OimoPhysicsEngine();
	}
}
