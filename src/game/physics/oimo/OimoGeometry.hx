package game.physics.oimo;

import oimo.common.Mat3;
import oimo.collision.geometry.ConvexGeometry;
import game.domain.overworld.location.physics.IGeometry;
import oimo.m.M;

class OimoGeometry implements IGeometry {

	public final geom : ConvexGeometry;

	public function new( geom : ConvexGeometry ) {
		this.geom = geom;
	}

	public function setVolume( value : Float ) {
		geom._volume = value;
	}

	public function getIntertiaCoeff() : Mat3 {
		var mat : Mat3 = new Mat3();
		M.mat3_toMat3( mat, geom._inertiaCoeff );
		return mat;
	}
}
