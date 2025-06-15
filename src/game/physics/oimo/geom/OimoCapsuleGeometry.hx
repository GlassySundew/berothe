package game.physics.oimo.geom;

import oimo.common.Mat3;
import oimo.collision.geometry.CapsuleGeometry;
import game.domain.overworld.location.physics.Types.Vec;
import oimo.m.M;

class OimoCapsuleGeometry extends CapsuleGeometry {

	public var mass : Float = 1;

	public function new( radius : Float, halfHeight : Float ) {
		super( radius, halfHeight );
	}
}
