package game.net.entity.component.model;

import net.NSMutableProperty;
import net.NSIntMap;
import game.domain.overworld.entity.component.model.EntityStats;
import net.NetNode;

class EntityStatsReplicator extends NetNode {

	@:s public var attacks : NSIntMap<NSMutableProperty<Float>> = new NSIntMap();

	public function new(
		entityStats : EntityStats,
		entityRepl : EntityReplicator,
		?parent
	) {
		super( parent );

		for ( equipSlotType => attack in entityStats.limbAttacks ) {
			attacks[equipSlotType] = new NSMutableProperty();
			attack.amount.addOnValue(
				( old, newVal ) -> attacks[equipSlotType].val = newVal
			);
		}
	}
}
