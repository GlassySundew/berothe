package game.physics.oimo.geom;

import oimo.common.Vec3;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import oimo.collision.geometry.BoxGeometry;
import game.domain.overworld.location.physics.geom.IBoxGeometry;
import oimo.m.M;

class OimoBoxGeometry extends BoxGeometry {

	public function new( halfSize : Vec3 ) {
		super( halfSize );
	}

	public function setSize( vec : ThreeDeeVector ) {
		_setSize( vec.div( 0.5 ).toOimo() );
	}

	public function setVolume( value : Float ) {
		_volume = value;
	}
}
