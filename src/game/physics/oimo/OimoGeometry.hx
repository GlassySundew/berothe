package game.physics.oimo;

import oimo.collision.geometry.ConvexGeometry;
import game.domain.overworld.location.physics.IGeometry;

class OimoGeometry implements IGeometry {

	public final geom : ConvexGeometry;
	
	public function new( geom : ConvexGeometry ) {
		this.geom = geom;
	}
}
