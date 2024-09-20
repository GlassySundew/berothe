package game.domain.overworld.item;

import core.IProperty;
import core.MutableProperty;
import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;

class Item {

	public final id : String;
	public final desc : ItemDescription;
	
	final itemContainer : MutableProperty<IItemContainer> = new MutableProperty();
	public var itemContainerProp(get, never) : IProperty<IItemContainer>;
	inline function get_itemContainerProp() : IProperty<IItemContainer> {
		return itemContainer;
	}

	public var amount : Int;

	public function new( itemDesc : ItemDescription, id : String ) {
		this.desc = itemDesc;
		this.id = id;
	}

	public function setContainer(cont : IItemContainer) {
		itemContainer.val = cont;
	}
}
