package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class ShadowPowerAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.shadow.power;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.shadow.power = v;
	}

	public function new() {
		super( val );
	}
}
