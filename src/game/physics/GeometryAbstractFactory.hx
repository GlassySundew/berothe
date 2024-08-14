package game.physics;

import oimo.collision.geometry.BoxGeometry;
import oimo.common.Vec3;
import game.domain.overworld.location.physics.geom.IBoxGeometry;
import game.physics.oimo.geom.OimoBoxGeometry;

class GeometryAbstractFactory {

	public static function box(
		xSize : Float,
		ySize : Float,
		zSize : Float
	) : IBoxGeometry {

		var geom = new BoxGeometry(
			new Vec3(
				xSize / 2,
				ySize / 2,
				zSize / 2
			)
		);

		var wrapper = new OimoBoxGeometry( geom );
		return wrapper;
	}
}
