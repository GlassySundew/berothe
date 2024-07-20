package game.physics;

import oimo.dynamics.rigidbody.ShapeConfig;
import game.physics.oimo.OimoShapeConfig;
import game.core.rules.overworld.location.physics.IShapeConfig;

class ShapeConfigFactory {

	public static function create() : IShapeConfig {

		return new OimoShapeConfig( new ShapeConfig() );
	}
}
