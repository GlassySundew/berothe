package game.domain.overworld.entity.component.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.item.model.IItemContainer;
import game.domain.overworld.item.model.ItemSlot;

class EntityEquip extends EntityItemHolderBase {

	public final equipSlots : Map<EntityEquipmentSlotType, ItemSlot> = [];
	public final equipSlotsDesc : Array<EntityEquipmentSlotType>;

	public function new( equipSlotsDesc : Array<EntityEquipmentSlotType> ) {
		this.equipSlotsDesc = equipSlotsDesc;

		initializeEquipSlots( equipSlotsDesc );
	}

	function initializeEquipSlots( equipSlotsDesc : Array<EntityEquipmentSlotType> ) {
		for ( equipSlotDesc in equipSlotsDesc ) {
			equipSlots[equipSlotDesc] = new EquipItemSlot( equipSlotDesc );
		}
	}

	function getItemSlotIterator() : Iterator<IItemContainer> {
		return equipSlots.iterator();
	}
}
