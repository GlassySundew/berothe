package game.physics.oimo;

import en.collide.RayCastCallback;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.ITransform;
import game.core.rules.overworld.location.physics.IGeometry;
import game.core.rules.overworld.location.physics.IPhysicsEngine;

/**
	manages constant convex emittions each frame
**/
class OimoGeometryCastEmitter {

	public final contactCB : RayCastCallback;

	final geom : IGeometry;
	final physics : IPhysicsEngine;

	public var start : ITransform;
	public var translation : ThreeDeeVector;

	public function new( geom : IGeometry, physics : IPhysicsEngine ) {
		this.geom = geom;
		this.physics = physics;
		contactCB = new RayCastCallback( physics );
	}

	function emit() {
		physics.convexCast( geom, start, translation, contactCB );
	}
}
