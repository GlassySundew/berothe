package game.physics;

import game.physics.oimo.OimoGeometry;
import game.physics.oimo.OimoRigidBody;
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

		var geom = GeometryAbstractFactory.box( xSize, ySize, zSize );

		var shapeConf : ShapeConfig = new ShapeConfig();
		shapeConf.geometry = Std.downcast( geom, OimoGeometry ).geom;

		return OimoRigidBodyShape.create( shapeConf );
	}

	public static function fromShape( shape : Shape ) : IRigidBodyShape {
		return new OimoRigidBodyShape( shape );
	}
}
