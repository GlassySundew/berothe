package game.domain.overworld.item;

import future.Future;
import core.IProperty;
import core.MutableProperty;
import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.model.EntityAdditiveStatType;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

class Item {

	public final id : String;
	public final desc : ItemDescription;
	public final disposed = new Future();
	public final stats : Array<EntityAdditiveStatBase>;

	final itemContainer : MutableProperty<IItemContainer> = new MutableProperty();
	public var itemContainerProp( get, never ) : IProperty<IItemContainer>;
	inline function get_itemContainerProp() : IProperty<IItemContainer> {
		return itemContainer;
	}

	public var amount( default, set ) : Int;
	inline function set_amount( value : Int ) : Int {
		if ( value == 0 ) dispose();
		return amount = value;
	}

	public function new(
		itemDesc : ItemDescription,
		id : String,
		amount = 1
	) {
		this.desc = itemDesc;
		this.id = id;
		this.amount = 1;

		if ( itemDesc.equippable ) {
			stats = [for ( stat in itemDesc.equipStats ) {
				EntityAdditiveStatType.build( stat.type, stat.amount );
			}];
		}
	}

	public function dispose() {
		disposed.resolve( true );
		setContainer( null );
		trace( "destroyoing item" );
	}

	public function setContainer( cont : IItemContainer ) {
		itemContainer.val = cont;
	}

	@:keep
	public function toString() : String {
		return "Item: " + desc.id;
	}
}
