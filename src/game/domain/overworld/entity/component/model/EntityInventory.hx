package game.domain.overworld.entity.component.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.EquipItemSlot;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

class EntityInventory extends EntityItemHolderBase {

	public final equipSlots : Map<EntityEquipmentSlotType, EquipItemSlot> = [];

	public var inventorySlots( default, null ) : Array<ItemSlot>;

	final baseInventorySize : Int;
	final model : EntityModelComponent;
	final equipSlotsDesc : Array<EntityEquipSlotDescription>;

	public function new(
		model : EntityModelComponent,
		baseInventorySize : Int,
		equipSlotsDesc : Array<EntityEquipSlotDescription>,
	) {
		this.equipSlotsDesc = equipSlotsDesc;
		this.baseInventorySize = baseInventorySize;
		this.model = model;

		createSlots();

		super();
	}

	function createSlots() {
		inventorySlots = [];

		for ( equipSlotDesc in equipSlotsDesc ) {
			var slot = new EquipItemSlot( equipSlotDesc );
			slot.itemProp.addOnValue( onItemChangedInSlot.bind( _, _, slot ) );
			equipSlots[equipSlotDesc.type] = slot;

			inventorySlots.push( slot );
		}
		
		for ( i in 0...baseInventorySize ) {
			inventorySlots.push( new ItemSlot() );
		}
	}

	function getItemSlotIterator() : Iterator<ItemSlot> {
		return inventorySlots.iterator();
	}

	// todo use it for regular as well when items that lie in inventory start giving stats
	function onItemChangedInSlot( oldItem : Item, newItem : Item, ?slot : EquipItemSlot ) {
		// removeStats( oldItem?.stats, slot );

		if ( newItem != null && newItem.stats.length > 0 ) {
			model.stats.addStats( newItem.stats, slot );
		}
	}
}
