package game.domain.overworld.item;

import util.Assert;
import signals.Signal;
import game.data.storage.item.ItemDescription;

class ItemFactory {

	static var ITEM_ID_STUB = 0;

	public final onItemCreated = new Signal<Item>();

	public function new() {}

	public inline function createItem( desc : ItemDescription ) : Item {
		#if client
		throw( "should not be called on client" );
		#end

		var item = new Item( desc, '${ITEM_ID_STUB++}' );
		onItemCreated.dispatch( item );

		return item;
	}

	public inline function split( sourceItem : Item ) : Array<Item> {
		var result = [];

		if ( sourceItem.desc.isSplittable ) {
			if ( sourceItem.amount.val < 10 ) {
				for ( i in 0...sourceItem.amount.val ) {
					result.push( createItem( sourceItem.desc ) );
					sourceItem.amount.val--;
				}
			} else {
				var originalAmount = sourceItem.amount.val;
				for ( i in 0...10 ) {
					var splittedItem = createItem( sourceItem.desc );
					result.push( splittedItem );
					var fraction = Std.int( originalAmount / 10 );
					if ( sourceItem.amount.val < fraction ) {
						splittedItem.amount.val = sourceItem.amount.val;
						sourceItem.amount.val = 0;
						break;
					}
					splittedItem.amount.val = fraction;
					sourceItem.amount.val -= splittedItem.amount.val;
				}
			}
		}

		return result;
	}
}
