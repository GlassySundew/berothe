package game.domain.overworld.item.model;

import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EquipItemSlot extends ItemSlot {

	public final equipType : EntityEquipSlotDescription;

	public function new( equipType : EntityEquipSlotDescription, ?restriction ) {
		super( equipType.priority, restriction );
		this.equipType = equipType;
		this.restriction.isEquipment = true;
		this.restriction.equipmentType = equipType.type;
	}
}
