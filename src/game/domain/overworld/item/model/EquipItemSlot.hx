package game.domain.overworld.item.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;

class EquipItemSlot extends ItemSlot {

	public final equipType : EntityEquipmentSlotType;

	public function new( equipType : EntityEquipmentSlotType, ?restriction ) {
		super( restriction );
		this.equipType = equipType;
		this.restriction.isEquipment = true;
		this.restriction.equipmentType = equipType;
	}
}
