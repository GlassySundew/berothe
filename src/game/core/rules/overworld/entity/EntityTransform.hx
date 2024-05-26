package game.core.rules.overworld.entity;

import core.MutableProperty;

class EntityTransform {

	public var x( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var y( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var z( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );

	var rotationX : Float;
	var rotationY : Float;
	var rotationZ : Float;

	public function new() {}

	public function setTransform( x : Float, y : Float, z : Float ) {
		this.x.val = x;
		this.y.val = y;
		this.z.val = z;
	}
}
