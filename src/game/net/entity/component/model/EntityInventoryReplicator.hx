package game.net.entity.component.model;

import game.domain.overworld.entity.component.model.EntityInventory;
import net.NetNode;

class EntityInventoryReplicator extends NetNode {

	public function new( entityInventory : EntityInventory, ?parent ) {
		super( parent );
	}
}
