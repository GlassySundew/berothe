package game.physics;

import game.physics.oimo.OimoRigidBodyShape;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.ShapeConfig;
import oimo.collision.geometry.BoxGeometry;
import util.Const;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;

class ShapeAbstractFactory {

	public static function box(
		xSize : Float,
		ySize : Float,
		zSize : Float
	) : IRigidBodyShape {

		var geom = new BoxGeometry(
			new Vec3(
				xSize / 2,

				ySize / 2,
				zSize / 2
			)
		);

		var shapeConf : ShapeConfig = new ShapeConfig();
		shapeConf.geometry = geom;

		return new OimoRigidBodyShape( shapeConf );
	}
}
