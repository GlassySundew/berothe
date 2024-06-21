package en.collide;

import signals.Signal2;
import signals.Signal;
import oimo.dynamics.rigidbody.Shape;
import oimo.collision.geometry.RayCastHit;
import oimo.dynamics.callback.RayCastClosest;

class RayCastCallback extends RayCastClosest {

	public final onShapeCollide : Signal2<Shape, RayCastHit> = new Signal2();

	public function new() {
		super();
	}

	override function process( shape : Shape, hit : RayCastHit ) {
		super.process( shape, hit );
		onShapeCollide.dispatch( shape, hit );
	}
}
