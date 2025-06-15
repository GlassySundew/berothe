package game.physics.oimo.geom;

import game.domain.overworld.location.physics.Types.Vec;
import game.domain.overworld.location.physics.geom.IBoxGeometry;

class OimoBoxGeomWrapper extends OimoGeometry implements IBoxGeometry {

	final boxGeom : OimoBoxGeometry;

	public inline function new( geom : OimoBoxGeometry ) {
		super( geom );
		this.boxGeom = geom;
	}

	public inline function setSize( vec : Vec ) {
		boxGeom.setSize( vec );
	}
}
