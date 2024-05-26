package game.client.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class ShadowBlurQualityAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.shadow.blur.quality;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.shadow.blur.quality = v;
	}

	public function new() {
		super( val );
	}
}
