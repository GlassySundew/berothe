package game.domain.overworld.entity.component.model.stat;

import game.data.storage.entity.model.EntityAdditiveStatType;

abstract class EntityAdditiveStatBase {

	public final type : EntityAdditiveStatType;
	public final amount : Float;
	var entity : OverworldEntity;

	public function new(
		type : EntityAdditiveStatType,
		?amount : Float = 1
	) {
		this.type = type;
		this.amount = amount;
	}
}
