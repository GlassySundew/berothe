package game.debug.accessor.network;

import core.MutableProperty.MutablePropertyBase;
import util.Settings;
import game.debug.HeapsOimophysicsDebugDraw;

class ChunkDebugViewAccessor extends MutablePropertyBase<Bool> {

	var draw : HeapsOimophysicsDebugDraw;

	override function get_val() : Bool {
		return super.get_val();
	}

	override function set_val( val : Bool ) : Bool {
		Settings.inst.params.debug.physicsDebugVisible.val = val;
		return super.set_val( val );
	}

	public function new() {
		var value : Bool = Settings.inst.params.debug.physicsDebugVisible.val;
		super( value );
	}
}
