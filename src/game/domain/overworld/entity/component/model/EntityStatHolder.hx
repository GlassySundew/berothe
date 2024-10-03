package game.domain.overworld.entity.component.model;

import util.Assert;
import core.MutableProperty;
import core.IProperty;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

/**
	works in 2 ways:

	*	server: collects stats and recalculates result into `amount` once they've been changed
	*	client: when needed extra syncronization, will work as a property to hold value sent from server

	the behaviour is determined between these 2 by field `receiver` property,
	if not null then its client
**/
class EntityStatHolder {

	public final stats : Array<EntityAdditiveStatBase> = [];

	final amountProp : MutableProperty<Float> = new MutableProperty();
	public var amount( get, default ) : IProperty<Float>;
	inline function get_amount() {
		return receiver != null ? receiver : amountProp;
	}

	var receiver : Null<IProperty<Float>>;

	public function new() {}

	public function setReceiver( property : IProperty<Float> ) {
		Assert.notNull( property );
		Assert.isNull( receiver );

		untyped stats.length = 0;
		receiver = property;
	}

	public function recalculate() {
		Assert.isNull( receiver );
		amountProp.val = Lambda.fold(
			stats,
			( item, result ) -> item.amount + result,
			0
		);
	}

	public function addStat( stat : EntityAdditiveStatBase ) {
		Assert.isNull( receiver );
		stats.push( stat );
		recalculate();
	}
}
