package game.physics;

import game.core.rules.overworld.location.physics.IRigidBodyShape;
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
