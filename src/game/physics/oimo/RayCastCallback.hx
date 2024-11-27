package game.physics.oimo;

import game.physics.oimo.OimoWrappedShape;
import util.Assert;
import game.domain.overworld.location.physics.IPhysicsEngine;
import signals.Signal2;
import signals.Signal;
import oimo.dynamics.rigidbody.Shape;
import game.domain.overworld.location.physics.RayCastHit;
import oimo.dynamics.callback.RayCastClosest;
import game.domain.overworld.location.physics.IRigidBodyShape;

class RayCastCallback extends RayCastClosest {

	public final onShapeCollide = new Signal<IRigidBodyShape, RayCastHit>();

	override function process( shape : Shape, hit : oimo.collision.geometry.RayCastHit ) {
		super.process( shape, hit );

		Assert.isOfType( shape, OimoWrappedShape );

		var rayCastWrapped = RayCastHit.fromOimo( hit );

		onShapeCollide.dispatch( Std.downcast( shape, OimoWrappedShape ), rayCastWrapped );
	}
}
