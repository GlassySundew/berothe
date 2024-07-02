package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOBlurRadiusAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.saoBlur.radius;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.saoBlur.radius = v;
	}

	public function new() {
		super( val );
	}
}
