package game.domain.overworld.item.model;

import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EquipItemSlot extends ItemSlot {

	public final desc : EntityEquipSlotDescription;

	public function new( desc : EntityEquipSlotDescription, ?restriction ) {
		super( desc.priority, restriction );
		this.desc = desc;
		this.restriction.isEquipment = true;
		this.restriction.equipmentType = desc.type;
	}
}
