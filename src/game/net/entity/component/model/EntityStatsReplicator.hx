package game.net.entity.component.model;

import game.domain.overworld.entity.component.model.EntityStats;
import net.NetNode;

class EntityStatsReplicator extends NetNode {


	
	public function new(
		entityStats : EntityStats,
		entityRepl : EntityReplicator,
		?parent
	) {
		super( parent );
		
	}
}
