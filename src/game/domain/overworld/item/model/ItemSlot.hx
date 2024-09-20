package game.domain.overworld.item.model;

import game.data.storage.item.ItemDescription;
import core.IProperty;
import core.MutableProperty;
import game.data.storage.item.ItemType;

class ItemSlot implements IItemContainer {

	public final restriction : ItemRestriction;

	public var itemProp( get, never ) : IProperty<Item>;
	function get_itemProp() : IProperty<Item> {
		return item;
	}
	final item : MutableProperty<Item> = new MutableProperty();

	public function new( ?restriction : ItemRestriction ) {
		this.restriction = restriction ?? new ItemRestriction();
	}

	public function giveItem( item : Item ) {
		item.setContainer( this );
		this.item.val = item;

		item.itemContainerProp.addOnValue(
			( oldCont, newCont ) -> {
				if ( oldCont != this ) {
					throw "bad logic, setting not persistent container for item";
				}
				this.item.val = null;
			},
			1
		);
	}

	public function removeItem( amount : Int = 1 ) {
		// todo make item amount reduce

		item.val = null;
	}

	public function getAcceptableStackAmount() : Int {
		// TODO return item stack amount
		return 1;
	}

	public function hasSpaceForItem( item : ItemDescription, amount : Null<Int> = 1 ) : Bool {
		// TODO container item insides check

		return
			this.item.val == null
			&& restriction.isFulfilledByItem( item );
	}
}
