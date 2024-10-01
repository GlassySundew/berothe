package game.domain.overworld.entity.component.model;

import game.data.storage.entity.body.model.EntityModelDescription;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;
import game.data.storage.item.ItemDescription.EquipStat;
import game.domain.overworld.item.Item;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.item.model.IItemContainer;
import game.domain.overworld.item.model.ItemSlot;

class EntityEquip extends EntityItemHolderBase {

	public final equipSlots : Map<EntityEquipmentSlotType, EquipItemSlot> = [];
	public final equipSlotsDesc : Array<EntityEquipSlotDescription>;

	final model : EntityModelComponent;

	public function new(
		model : EntityModelComponent,
		equipSlotsDesc : Array<EntityEquipSlotDescription>
	) {
		this.equipSlotsDesc = equipSlotsDesc;
		this.model = model;

		initializeEquipSlots( equipSlotsDesc );

		super();
	}

	function initializeEquipSlots( equipSlotsDesc : Array<EntityEquipSlotDescription> ) {
		for ( equipSlotDesc in equipSlotsDesc ) {
			var slot = new EquipItemSlot( equipSlotDesc );
			slot.itemProp.addOnValue( onItemChangedInSlot.bind( _, _, slot ) );
			equipSlots[equipSlotDesc.type] = slot;
		}
	}

	function getItemSlotIterator() : Iterator<ItemSlot> {
		return equipSlots.iterator();
	}

	function onItemChangedInSlot( oldItem : Item, newItem : Item, slot : EquipItemSlot ) {
		// removeStats( oldItem?.stats, slot );

		if ( newItem != null && newItem.stats.length > 0 ) {
			model.stats.addStats( newItem.stats, slot );
		}
	}

	function removeStats( stats : Array<EntityAdditiveStatBase>, slot : EquipItemSlot ) {
		if ( stats == null ) return;
	}
}
