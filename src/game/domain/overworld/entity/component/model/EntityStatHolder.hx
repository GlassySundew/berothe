package game.domain.overworld.entity.component.model;

import util.Assert;
import core.MutableProperty;
import core.IProperty;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

class EntityStatHolder {

	public final stats : Array<EntityAdditiveStatBase> = [];

	final amountProp : MutableProperty<Float> = new MutableProperty();
	public var amount( get, default ) : IProperty<Float>;
	inline function get_amount() {
		// return receiver != null ? receiver : amountProp;
		return amountProp;
	}

	// var receiver : Null<IProperty<Float>>;

	public function new() {}

	// @:deprecated
	// private final function setReceiver( property : IProperty<Float> ) {
	// 	Assert.notNull( property );
	// 	Assert.isNull( receiver );
	// 	untyped stats.length = 0;
	// 	receiver = property;
	// }

	public function recalculate() {
		// Assert.isNull( receiver );
		amountProp.val = Lambda.fold(
			stats,
			( item, result ) -> item.amount + result,
			0
		);
	}

	public function addStat( stat : EntityAdditiveStatBase ) {
		// Assert.isNull( receiver );
		stats.push( stat );
		recalculate();
	}
}
