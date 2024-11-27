package game.physics;

import game.physics.oimo.geom.OimoBoxGeomWrapper;
import game.physics.oimo.OimoGeometry;
import game.physics.oimo.geom.OimoCapsuleGeometry;
import oimo.collision.geometry.CapsuleGeometry;
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

		var wrapper = new OimoBoxGeometry( new Vec3(
			xSize / 2,
			ySize / 2,
			zSize / 2
		) );
		return new OimoBoxGeomWrapper( wrapper );
	}

	public static function capsule(
		xSize : Float,
		zSize : Float
	) : OimoGeometry {

		var wrapper = new OimoCapsuleGeometry(
			xSize / 2,
			zSize / 2
		);
		return new OimoGeometry( wrapper );
	}
}
