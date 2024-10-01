package game.domain.overworld.entity.component.model.stat;

import game.data.storage.entity.model.EntityAdditiveStatType;

abstract class EntityAdditiveStatBase {

	public final type : EntityAdditiveStatType;
	public final amount : Int;
	var entity : OverworldEntity;

	public function new(
		type : EntityAdditiveStatType,
		?amount : Int = 1
	) {
		this.type = type;
		this.amount = amount;
	}

	/** has to be overriden **/
	public function attach( entity : OverworldEntity ) : Void {
		this.entity = entity;
	}

	abstract public function detach() : Void;
}
