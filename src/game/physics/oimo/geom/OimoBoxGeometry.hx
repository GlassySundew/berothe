package game.physics.oimo.geom;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import oimo.collision.geometry.BoxGeometry;
import game.domain.overworld.location.physics.geom.IBoxGeometry;

class OimoBoxGeometry extends OimoGeometry implements IBoxGeometry {

	public final boxGeom : BoxGeometry;

	public function new( geom : BoxGeometry ) {
		this.boxGeom = geom;
		super( geom );
	}

	public function setSize( vec : ThreeDeeVector ) {
		boxGeom.setSize( vec.div( 0.5 ).toOimo() );
	}
}
