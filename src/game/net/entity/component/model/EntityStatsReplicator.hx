package game.net.entity.component.model;

import net.NSMutableProperty;
import net.NSIntMap;
import game.domain.overworld.entity.component.model.EntityStats;
import net.NetNode;

/**
	don't need to replicate attack numbers as they are count from actual model on-client
**/
class EntityStatsReplicator extends NetNode {

	var entityStats : EntityStats;

	public function new(
		entityStats : EntityStats,
		entityRepl : EntityReplicator,
		?parent
	) {
		super( parent );
		this.entityStats = entityStats;

	}

	public function followClient(
		entityStats : EntityStats
	) {
		this.entityStats = entityStats;
		for ( equipSlotType => limbAttack in entityStats.limbAttacks ) {
			// limbAttack.setReceiver( attacks[equipSlotType] );
		}
	}
}
