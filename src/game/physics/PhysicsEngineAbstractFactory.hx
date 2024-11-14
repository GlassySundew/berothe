package game.physics;

import oimo.common.Setting;
import game.physics.oimo.OimoPhysicsEngine;
import game.domain.overworld.location.physics.IPhysicsEngine;

class PhysicsEngineAbstractFactory {

	public static function create() : IPhysicsEngine {
		Setting.defaultRestitution = 0;
		Setting.defaultFriction = 1;
		Setting.defaultDensity = 1;
		return new OimoPhysicsEngine();
	}
}
