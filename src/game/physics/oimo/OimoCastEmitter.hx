package game.physics.oimo;

import util.Util;
import en.collide.RayCastCallback;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.ITransform;
import game.core.rules.overworld.location.physics.IGeometry;
import game.core.rules.overworld.location.physics.IPhysicsEngine;

/**
	manages rb that is `CASTED`
**/
class OimoCastEmitter {

	public final contactCB : RayCastCallback;

	final geom : IGeometry;
	final physics : IPhysicsEngine;

	public final sourceTransform : ITransform;
	public var translation : ThreeDeeVector = new ThreeDeeVector();

	public var rotation : Float = 0;

	public function new(
		geom : IGeometry,
		sourceTransform : ITransform,
		physics : IPhysicsEngine
	) {
		this.geom = geom;
		this.physics = physics;
		this.sourceTransform = sourceTransform;
		contactCB = new RayCastCallback();
	}

	public function emit() {
		contactCB.clear();

		physics.convexCast( geom, sourceTransform, translation, contactCB );
	}
}
