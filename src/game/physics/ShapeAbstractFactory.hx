package game.physics;

import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.ShapeConfig;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import game.physics.oimo.OimoGeometry;
import game.physics.oimo.OimoRigidBodyShape;

class ShapeAbstractFactory {

	public static function box(
		xSize : Float,
		ySize : Float,
		zSize : Float
	) : IRigidBodyShape {

		var geom = GeometryAbstractFactory.box( xSize, ySize, zSize );

		var shapeConfig = ShapeConfigFactory.create();
		shapeConfig.setGeometry( geom );

		return OimoRigidBodyShape.create( shapeConfig );
	}
}
