package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOBlurLinearityAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.saoBlur.linear;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.saoBlur.linear = v;
	}

	public function new() {
		super( val );
	}
}
