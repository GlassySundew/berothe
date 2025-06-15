package game.physics.oimo;

import util.Util;
import game.physics.oimo.RayCastCallback;
import game.domain.overworld.location.physics.Types.Vec;
import game.domain.overworld.location.physics.ITransform;
import game.domain.overworld.location.physics.IGeometry;
import game.domain.overworld.location.physics.IPhysicsEngine;

/**
	manages rb that is `TRIGGER`
**/
class OimoCastEmitter {

	public final contactCB : RayCastCallback;

	final geom : IGeometry;
	final physics : IPhysicsEngine;

	public final sourceTransform : ITransform;
	public var translation : Vec = new Vec();

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
