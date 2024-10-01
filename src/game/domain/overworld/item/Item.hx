package game.domain.overworld.item;

import core.IProperty;
import core.MutableProperty;
import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.model.EntityAdditiveStatType;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

class Item {

	public final id : String;
	public final desc : ItemDescription;

	public final stats : Array<EntityAdditiveStatBase>;

	final itemContainer : MutableProperty<IItemContainer> = new MutableProperty();
	public var itemContainerProp( get, never ) : IProperty<IItemContainer>;
	inline function get_itemContainerProp() : IProperty<IItemContainer> {
		return itemContainer;
	}

	public var amount : Int;

	public function new( itemDesc : ItemDescription, id : String ) {
		this.desc = itemDesc;
		this.id = id;

		stats = [for ( stat in itemDesc.equipStats ) {
			EntityAdditiveStatType.build( stat.type, stat.amount );
		}];
	}

	public function setContainer( cont : IItemContainer ) {
		itemContainer.val = cont;
	}
}
