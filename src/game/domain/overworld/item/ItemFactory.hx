package game.domain.overworld.item;

import util.Assert;
import signals.Signal;
import game.data.storage.item.ItemDescription;

class ItemFactory {

	static var ITEM_ID_STUB = 0;

	public final onItemCreated = new Signal<Item>();

	public function new() {}

	public function createItem( desc : ItemDescription ) : Item {
		#if client
		throw( "should not be called on client" );
		#end

		var item = new Item( desc, '${ITEM_ID_STUB++}' );
		onItemCreated.dispatch( item );

		return item;
	}
}
