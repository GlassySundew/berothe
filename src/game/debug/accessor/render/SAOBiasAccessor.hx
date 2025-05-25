package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOBiasAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return ClientBoot.inst.renderer.sao.shader.bias;
	}

	override function set_val( v : Float ) : Float {
		return ClientBoot.inst.renderer.sao.shader.bias = v;
	}

	public function new() {
		super( val );
	}
}
