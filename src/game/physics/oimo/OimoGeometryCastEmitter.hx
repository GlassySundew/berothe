package game.physics.oimo;

import game.core.rules.overworld.location.physics.IGeometry;
import game.core.rules.IUpdatable;
import game.core.rules.overworld.location.physics.IPhysicsEngine;

/**
	manages constant convex emittions each frame
**/
class OimoGeometryCastEmitter implements IUpdatable {

	final geom : IGeometry;
	final physics : IPhysicsEngine;

	public function new( geom : IGeometry, physics : IPhysicsEngine ) {
		this.geom = geom;
		this.physics = physics;
	}

	public function update( dt : Float, tmod : Float ) {
		// physics.conv
	}
}
