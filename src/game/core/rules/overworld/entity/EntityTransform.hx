package game.core.rules.overworld.entity;

import core.MutableProperty;

class EntityTransform {

	public var x( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var y( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var z( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );

	public var velX( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var velY( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var velZ( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );

	public var rotationX( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var rotationY( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );
	public var rotationZ( default, null ) : MutableProperty<Float> = new MutableProperty( 0. );

	public function new() {}

	public function setPosition( x : Float, y : Float, z : Float ) {
		this.x.val = x;
		this.y.val = y;
		this.z.val = z;
	}
}
