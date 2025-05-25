package game.debug.accessor.render;

import core.MutableProperty.MutablePropertyBase;

class ShadowSizeAccessor extends MutablePropertyBase<Int> {

	override function get_val() : Int {
		return Std.int( Math.log( ClientBoot.inst.renderer.shadow.size ) / Math.log( 2 ) );
	}

	override function set_val( v : Int ) : Int {
		return ClientBoot.inst.renderer.shadow.size = Std.int( Math.pow( 2, Std.int( v ) ) );
	}

	public function new() {
		super( val );
	}
}
