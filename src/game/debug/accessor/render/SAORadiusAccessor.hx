package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAORadiusAccessor extends MutablePropertyBase<Float> {

	override function get_val() : Float {
		return Boot.inst.renderer.sao.shader.sampleRadius;
	}

	override function set_val( v : Float ) : Float {
		return Boot.inst.renderer.sao.shader.sampleRadius = v;
	}

	public function new() {
		super( val );
	}
}
