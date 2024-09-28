package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.model.ItemSlot;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

abstract class EntityItemHolderBase {

	var slots : Array<ItemSlot>;

	public function new() {
		updateSlots();
	}

	public function tryPickupItem( item : Item ) {
		for ( equipSlot in slots ) {
			if ( equipSlot.hasSpaceForItem( item.desc, item.amount ) ) {
				equipSlot.giveItem( item );
				return ItemPickupAttemptResult.success();
			}
		}
		return ItemPickupAttemptResult.failure();
	}

	public function hasSpaceForItem( item : ItemDescription, amount = 1 ) : Bool {
		for ( equipSlot in slots ) {
			if ( equipSlot.hasSpaceForItem( item, amount ) ) {
				return true;
			}
		}
		return false;
	}

	function updateSlots() {
		slots = [];
		for ( i in getItemSlotIterator() ) {
			slots.push( i );
		}
		slots.sort( ( slot1, slot2 ) -> slot2.priority - slot1.priority );
	}

	abstract function getItemSlotIterator() : Iterator<ItemSlot>;
}
