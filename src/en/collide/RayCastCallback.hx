package en.collide;

import game.core.rules.overworld.location.physics.IPhysicsEngine;
import signals.Signal2;
import signals.Signal;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.RayCastHit;
import oimo.dynamics.callback.RayCastClosest;
import game.core.rules.overworld.location.physics.IRigidBodyShape;

class RayCastCallback extends RayCastClosest {

	public final onShapeCollide = new Signal<IRigidBodyShape, RayCastHit>();

	final physics : IPhysicsEngine;

	public function new( physics : IPhysicsEngine ) {
		super();
		this.physics = physics;
	}

	override function process( shape : Shape, hit : oimo.collision.geometry.RayCastHit ) {
		super.process( shape, hit );
		var shapeWrapped = physics.getShapeByOimo( shape );
		var rayCastWrapped = RayCastHit.fromOimo( hit );

		onShapeCollide.dispatch( shapeWrapped, rayCastWrapped );
	}
}
