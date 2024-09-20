package game.domain.overworld.entity.component.model;

import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.IItemContainer;

abstract class EntityItemHolderBase {

	public function tryPickupItem( item : Item ) {
		for ( equipSlot in getItemSlotIterator() ) {
			if ( equipSlot.hasSpaceForItem( item.desc, item.amount ) ) {
				equipSlot.giveItem( item );
				return ItemPickupAttemptResult.success();
			}
		}
		return ItemPickupAttemptResult.failure();
	}

	public function hasSpaceForItem( item : ItemDescription, amount = 1 ) : Bool {
		for ( equipSlot in getItemSlotIterator() ) {
			if ( equipSlot.hasSpaceForItem( item, amount ) ) {
				return true;
			}
		}
		return false;
	}

	abstract function getItemSlotIterator() : Iterator<IItemContainer>;
}
