package game.client.debug.accessor.physics;

import core.MutableProperty.MutablePropertyBase;
import util.Settings;
import game.client.debug.HeapsOimophysicsDebugDraw;

class PhysicsDebugViewAccessor extends MutablePropertyBase<Bool> {

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
