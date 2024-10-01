package game.domain.overworld.entity.component.model;

import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

class EntityStatHolder {

	public final stats : Array<EntityAdditiveStatBase> = [];

	public function new() {}

	public function addStat( stat : EntityAdditiveStatBase ) {
		stats.push( stat );
	}
}
