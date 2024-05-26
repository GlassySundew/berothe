package game.client.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class ShadowBlurRadiusAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.shadow.blur.radius;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.shadow.blur.radius = v;
	}

	public function new() {
		super( val );
	}
}
