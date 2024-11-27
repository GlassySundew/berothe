package game.domain.overworld.item.model;

import game.data.storage.item.ItemDescription;
import core.IProperty;
import core.MutableProperty;
import game.data.storage.item.ItemType;

class ItemSlot implements IItemContainer {

	public final restriction : ItemRestriction;
	public final priority : Int;

	final item : MutableProperty<Item> = new MutableProperty();
	public var itemProp( get, never ) : IProperty<Item>;
	function get_itemProp() : IProperty<Item> {
		return item;
	}

	public function new(
		?priority : Int = 0,
		?restriction : ItemRestriction
	) {
		this.priority = priority;
		this.restriction = restriction ?? new ItemRestriction();
	}

	public function dispose() {
		item.val?.dispose();
	}

	public function giveItem( itemGiven : Item ) {
		if ( item.val != null ) {
			if ( item.val.desc == itemGiven.desc ) {
				if (
					item.val.amount.getValue() + itemGiven.amount.getValue() <= item.val.desc.stackSize
					|| item.val.desc.isUnlimitedStackSize() //
				) {
					item.val.amount.val += itemGiven.amount.val;
					itemGiven.amount.val = 0;
				} else if (
					item.val.amount.getValue() + itemGiven.amount.getValue() > item.val.desc.stackSize //
				) {
					itemGiven.amount.val -= item.val.desc.stackSize - item.val.amount.val;
					item.val.amount.val = item.val.desc.stackSize;
				}
			} else {
				trace( "ERROR: TRYING TO PICKUP ITEM TO OCCUPIED CELL WITH NON-COMPATIBLE ITEM: " + item, itemGiven );
			}

			return;
		}

		itemGiven.setContainer( this );
		item.val = itemGiven;

		itemGiven.itemContainerProp.addOnValue(
			( oldCont, newCont ) -> {
				if ( newCont == this ) return;
				item.val = null;
			}, 1
		);
	}

	public function removeItem( amount : Int = 1 ) {
		// todo make item amount reduce

		item.val?.setContainer( null );
		item.val = null;
	}

	public function getAcceptableStackAmount() : Int {
		// TODO return item stack amount
		return 1;
	}

	public function hasSpaceForItem(
		itemDesc : ItemDescription,
		amount : Null<Int> = 1
	) : Bool {
		// TODO container item insides check (в таком случае обращаемся внутрь предмета)

		return
			( item.val == null
				|| (
					item.val.desc == itemDesc
					&& item.val.canFitMoreItemsIn()
				) //
			) && restriction.isFulfilledByItem( itemDesc );
	}
}
