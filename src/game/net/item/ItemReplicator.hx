package game.net.item;

import hxbit.NetworkHost;
import game.data.storage.DataStorage;
import future.Future;
import game.domain.overworld.item.Item;
import net.NetNode;

class ItemReplicator extends NetNode {

	public var item( default, null ) : Future<Item> = new Future();

	@:s var itemDescriptionId : String;
	@:s var id : String;

	public function new( item : Item, ?parent ) {
		super( parent );

		this.item.resolve( item );
		itemDescriptionId = item.desc.id.toString();
		id = item.id;

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

		var desc = DataStorage.inst.itemStorage.getDescriptionById( itemDescriptionId );
		var itemLocal = new Item( desc, id );

		item.resolve( itemLocal );
	}

	@:keep
	public function toString() : String {
		return "ItemReplicator: " + item?.result?.desc.id;
	}
}
