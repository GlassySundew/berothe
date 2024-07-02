package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOBlurQualityAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.saoBlur.quality;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.saoBlur.quality = v;
	}

	public function new() {
		super( val );
	}
}
