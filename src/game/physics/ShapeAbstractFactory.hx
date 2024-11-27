package game.physics;

import game.physics.oimo.OimoWrappedShape;
import dn.M;
import game.physics.oimo.OimoShapeConfig;
import game.domain.overworld.location.physics.IRigidBodyShape;

class ShapeAbstractFactory {

	public static function box(
		xSize : Float,
		ySize : Float,
		zSize : Float
	) : IRigidBodyShape {

		var geom = GeometryAbstractFactory.box( xSize, ySize, zSize );

		var shapeConfig = ShapeConfigFactory.create();
		shapeConfig.setGeometry( geom );

		return new OimoWrappedShape( shapeConfig );
	}

	public static function capsule(
		xSize : Float,
		zSize : Float
	) : IRigidBodyShape {

		var geom = GeometryAbstractFactory.capsule( xSize, zSize );

		var shapeConfig = ShapeConfigFactory.create();
		shapeConfig.setGeometry( geom );

		var shape = new OimoWrappedShape( shapeConfig );
		shape.setLocalRotation( M.toRad( 90 ), 0, 0 );
		return shape;
	}
}
