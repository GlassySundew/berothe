package game.physics;

import game.core.rules.overworld.location.IPhysicsEngine;

class PhysicsEngineAbstractFactory {

	public static function create() : IPhysicsEngine {
		return new OimoPhysicsEngine();
	}
}
