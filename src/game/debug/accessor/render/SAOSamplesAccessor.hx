package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class SAOSamplesAccessor extends MutablePropertyBase<Int> {

	override function get_val() : Int {
		return Boot.inst.renderer.sao.shader.numSamples;
	}

	override function set_val( v : Int ) : Int {
		return Boot.inst.renderer.sao.shader.numSamples = v;
	}

	public function new() {
		super( val );
	}
}
