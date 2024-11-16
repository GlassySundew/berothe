package game.net.item;

import net.NSMutableProperty;
import hxbit.NetworkHost;
import game.data.storage.DataStorage;
import future.Future;
import game.domain.overworld.item.Item;
import net.NetNode;

class ItemReplicator extends NetNode {

	public var item( default, null ) : Future<Item> = new Future();

	@:s var itemDescriptionId : String;
	@:s var id : String;
	@:s final amount : NSMutableProperty<Int> = new NSMutableProperty();

	public function new( item : Item, ?parent ) {
		super( parent );

		this.item.resolve( item );
		itemDescriptionId = item.desc.id.toString();
		id = item.id;

		item.amount.subscribeProp( amount );

		item.disposed.then( _ -> {
			onItemDisposed();
		} );
	}

	function onItemDisposed() {
		unregister( NetworkHost.current );
		parent?.removeChild( this );
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.itemStorage.getById( itemDescriptionId );
		var itemLocal = new Item( desc, id );

		amount.subscribeProp( itemLocal.amount );

		item.resolve( itemLocal );
	}

	@:keep
	public function toString() : String {
		return "ItemReplicator: " + item?.result?.desc.id;
	}
}
