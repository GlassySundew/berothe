package game.debug.accessor;

import core.MutableProperty;
import core.MutableProperty.MutablePropertyBase;
import util.Settings;
import game.debug.HeapsOimophysicsDebugDraw;

class MutablePropertyAccessor<T> extends MutablePropertyBase<T> {

	final prop : MutableProperty<T>;

	override function set_val( val : T ) : T {
		prop.val = val;
		return super.set_val( val );
	}

	public function new( prop : MutableProperty<T> ) {
		this.prop = prop;
		super( prop.val );
	}
}
