package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

class EntityInventory extends EntityItemHolderBase {

	final baseInventorySize : Int;
	public final inventorySlots : Array<ItemSlot>;

	public function new( baseInventorySize : Int ) {
		this.baseInventorySize = baseInventorySize;

		inventorySlots = createInventorySlots( baseInventorySize );
	}

	function createInventorySlots( size : Int ) : Array<ItemSlot> {
		return [for ( i in 0...size ) {
			new ItemSlot();
		}];
	}

	function getItemSlotIterator() : Iterator<IItemContainer> {
		return inventorySlots.iterator();
	}
}
