package game.physics.oimo;

import util.MathUtil;
import game.physics.oimo.OimoWrappedShape;
import util.Assert;
import game.domain.overworld.location.physics.IPhysicsEngine;
import signals.Signal2;
import signals.Signal;
import oimo.dynamics.rigidbody.Shape;
import game.domain.overworld.location.physics.RayCastHit;
import oimo.dynamics.callback.RayCastClosest;
import game.domain.overworld.location.physics.IRigidBodyShape;

class RayCastCallback extends oimo.dynamics.callback.RayCastCallback {

	public final onShapeCollide = new Signal<IRigidBodyShape, RayCastHit>();

	public var contacts( default, null ) : Array<RayCastClosest> = [];

	public var hit : Bool = false;

	var lowestFraction = 0;

	public inline function clear() {
		hit = false;
		contacts.resize( 0 );
	}

	public inline function sort() {
		contacts.sort( ( contact1, contact2 ) -> dn.M.sign( contact1.fraction - contact2.fraction ) );
	}

	override function process( shape : Shape, hit : oimo.collision.geometry.RayCastHit ) {
		Assert.isOfType( shape, OimoWrappedShape );

		this.hit = true;

		var contact = new RayCastClosest();
		contact.process( shape, hit );
		contacts.push( contact );
		// if ( hit.fraction < hitfraction ) {

		// }

		var rayCastWrapped = RayCastHit.fromOimo( hit );

		onShapeCollide.dispatch( Std.downcast( shape, OimoWrappedShape ), rayCastWrapped );
	}
}
