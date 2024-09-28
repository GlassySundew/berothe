package game.domain.overworld.entity.component.model;

import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.item.model.IItemContainer;
import game.domain.overworld.item.model.ItemSlot;

class EntityEquip extends EntityItemHolderBase {

	public final equipSlots : Map<EntityEquipmentSlotType, ItemSlot> = [];
	public final equipSlotsDesc : Array<EntityEquipSlotDescription>;

	public function new( equipSlotsDesc : Array<EntityEquipSlotDescription> ) {
		this.equipSlotsDesc = equipSlotsDesc;

		initializeEquipSlots( equipSlotsDesc );

		super();
	}

	function initializeEquipSlots( equipSlotsDesc : Array<EntityEquipSlotDescription> ) {
		for ( equipSlotDesc in equipSlotsDesc ) {
			equipSlots[equipSlotDesc.type] = new EquipItemSlot( equipSlotDesc );
		}
	}

	function getItemSlotIterator() : Iterator<ItemSlot> {
		return equipSlots.iterator();
	}
}
