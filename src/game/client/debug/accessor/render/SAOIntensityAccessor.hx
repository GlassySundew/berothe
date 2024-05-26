package game.client.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOIntensityAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.sao.shader.intensity;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.sao.shader.intensity = v;
	}

	public function new() {
		super( val );
	}
}
