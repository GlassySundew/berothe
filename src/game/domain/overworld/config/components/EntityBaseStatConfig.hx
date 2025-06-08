package game.domain.overworld.config.components;

import game.data.storage.entity.body.model.EntityBaseStatsDescription;

class EntityBaseStatConfig {

	public var baseHp : Int;
	public var baseDefense : Int;

	public inline function new( baseStats : EntityBaseStatsDescription ) {

		baseHp = baseStats.baseHp;
		baseDefense = baseStats.baseDefence;
	}
}
