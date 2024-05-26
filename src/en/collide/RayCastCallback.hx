package en.collide;

import signals.Signal2;
import signals.Signal1;
import oimo.dynamics.rigidbody.Shape;
import oimo.collision.geometry.RayCastHit;
import oimo.dynamics.callback.RayCastClosest;

class RayCastCallback extends RayCastClosest {

	public final onProcess : Signal2<Shape, RayCastHit> = new Signal2();

	public function new() {
		super();
	}

	override function process( shape : Shape, hit : RayCastHit ) {
		super.process( shape, hit );
		onProcess.dispatch( shape, hit );
	}
}
