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

	public function giveItem( item : Item ) {
		if ( this.item.val != null ) {
			if ( this.item.val.desc == item.desc ) {
				// todo partial pouring (incomplete amount transfer)
				this.item.val.amount.val += item.amount.val;
			} else {
				trace( "ERROR: TRYING TO PICKUP ITEM TO OCCUPIED CELL WITH NON-COMPATIBLE ITEM: " + this.item, item );
			}
			return;
		}

		item.setContainer( this );
		this.item.val = item;

		item.itemContainerProp.addOnValue(
			( oldCont, newCont ) -> {
				if ( newCont == this ) return;
				this.item.val = null;
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
		// TODO container item insides check

		return
			( this.item.val == null
				|| ( this.item.val.desc == itemDesc // todo also require stack size
				) )
				&& restriction.isFulfilledByItem( itemDesc );
	}
}
