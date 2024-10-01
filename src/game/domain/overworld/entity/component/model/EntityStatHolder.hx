package game.domain.overworld.entity.component.model;

import core.MutableProperty;
import core.IProperty;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

class EntityStatHolder {

	public final stats : Array<EntityAdditiveStatBase> = [];

	final amountProp : MutableProperty<Float> = new MutableProperty();
	public var amount( get, default ) : IProperty<Float>;
	inline function get_amount() {
		return amountProp;
	}

	public function new() {}

	public function recalculate() {
		amountProp.val = Lambda.fold(
			stats,
			( item, result ) -> item.amount + result,
			0
		);
	}

	public function addStat( stat : EntityAdditiveStatBase ) {
		stats.push( stat );
		recalculate();
	}
}
