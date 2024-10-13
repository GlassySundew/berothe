package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.model.ItemSlot;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

abstract class EntityItemHolderBase {

	/**
		слоты сервиса
	**/
	var slots : Array<ItemSlot>;

	public function new() {
		updateSlots();
	}

	#if !debug inline #end
	public function hasItem( desc : ItemDescription, amount = 1 ) {
		var result = false;
		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if (
				item != null
				&& item.desc == desc
				&& item.amount >= amount
			) {
				result = true;
				break;
			}
		}
		return result;
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

	#if !debug inline #end
	public function removeItem( itemDesc : ItemDescription, amount = 1 ) : Int {
		var amountLeftToRemove = amount;
		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if ( item == null || item.desc != itemDesc ) continue;

			if ( item.amount >= amountLeftToRemove ) {
				item.amount -= amountLeftToRemove;
				amountLeftToRemove = 0;
				break;
			} else {
				amountLeftToRemove -= item.amount;
				item.amount = 0;
			}
		}
		return amountLeftToRemove;
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
