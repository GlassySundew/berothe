package game.domain.overworld.entity;

import signals.Signal;
import core.MutableProperty;

class EntityTransform {

	public final x = new MutableProperty( 0. );
	public final y = new MutableProperty( 0. );
	public final z = new MutableProperty( 0. );

	public final velX = new MutableProperty( 0. );
	public final velY = new MutableProperty( 0. );
	public final velZ = new MutableProperty( 0. );

	public final rotationX = new MutableProperty( 0. );
	public final rotationY = new MutableProperty( 0. );
	public final rotationZ = new MutableProperty( 0. );

	public final onTakeControl = new Signal();
	public final onReleaseControl = new Signal();

	public function new() {}

	public function setPosition( x : Float, y : Float, z : Float ) {
		onTakeControl.dispatch();
		this.x.val = x;
		this.y.val = y;
		this.z.val = z;
		onReleaseControl.dispatch();
	}

	public function setRotation( x : Float, y : Float, z : Float ) {
		this.rotationX.val = x;
		this.rotationY.val = y;
		this.rotationZ.val = z;
	}

	@:keep
	public function toString() : String {
		return "EntityTransform: x : " + x.val + ", y : " + y.val + ", z : " + z.val + ";";
	}
}
