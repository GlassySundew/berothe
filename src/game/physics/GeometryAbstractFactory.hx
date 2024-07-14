package game.physics;

import game.physics.oimo.OimoGeometry;
import oimo.common.Vec3;
import oimo.collision.geometry.BoxGeometry;
import game.core.rules.overworld.location.physics.IGeometry;

class GeometryAbstractFactory {

	public static function box(
		xSize : Float,
		ySize : Float,
		zSize : Float
	) : IGeometry {

		var geom = new BoxGeometry(
			new Vec3(
				xSize / 2,
				ySize / 2,
				zSize / 2
			)
		);

		var wrapper = new OimoGeometry( geom );
		return wrapper;
	}
}
