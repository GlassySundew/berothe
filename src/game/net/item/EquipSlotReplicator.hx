package game.net.item;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.ItemSlot;

class EquipSlotReplicator extends ItemSlotReplicator {

	@:s public final slotType : EntityEquipmentSlotType;

	public function new( slotType : EntityEquipmentSlotType, itemSlot : ItemSlot, ?parent ) {
		super( itemSlot, parent );
		this.slotType = slotType;
		
	}
}
