package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOBlurRadiusAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return ClientBoot.inst.renderer.saoBlur.radius;
	}

	override function set_val( v : Float ) : Float {
		return ClientBoot.inst.renderer.saoBlur.radius = v;
	}

	public function new() {
		super( val );
	}
}
