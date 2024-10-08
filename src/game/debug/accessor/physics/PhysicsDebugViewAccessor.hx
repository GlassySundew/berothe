package game.debug.accessor.physics;

import core.MutableProperty.MutablePropertyBase;
import util.Settings;
import game.debug.HeapsOimophysicsDebugDraw;

class PhysicsDebugViewAccessor extends MutablePropertyBase<Bool> {

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
