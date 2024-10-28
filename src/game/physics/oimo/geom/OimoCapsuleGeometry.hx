package game.physics.oimo.geom;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

class OimoCapsuleGeometry extends OimoGeometry {
	
	public final capsuleGeom : oimo.collision.geometry.CapsuleGeometry;

	public function new( geom : oimo.collision.geometry.CapsuleGeometry ) {
		this.capsuleGeom = geom;
		super( geom );
	}
}