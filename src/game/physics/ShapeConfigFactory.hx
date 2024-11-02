package game.physics;

import oimo.dynamics.rigidbody.ShapeConfig;
import game.physics.oimo.OimoShapeConfig;
import game.domain.overworld.location.physics.IShapeConfig;

class ShapeConfigFactory {

	public static function create() : IShapeConfig {
		var config = new ShapeConfig();
		return new OimoShapeConfig(config);
	}
}
