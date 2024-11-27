package game.net.item;

import core.IProperty;
import net.NSMutableProperty;
import rx.disposables.Composite;
import rx.disposables.ISubscription;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.net.CoreReplicator;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;
import net.NetNode;

class ItemSlotReplicator extends NetNode {

	public var itemSlot( default, null ) : ItemSlot;
	var binder : Composite = new Composite();

	@:s final itemReplicator : NSMutableProperty<ItemReplicator>;
	public var itemReplicatorProp( get, default ) : IProperty<ItemReplicator>;
	inline function get_itemReplicatorProp() {
		return itemReplicator;
	}

	public function new( itemSlot : ItemSlot, ?parent ) {
		super( parent );

		itemReplicator = new NSMutableProperty( null, this );
		this.itemSlot = itemSlot;

		addOnItem( onItemChanged );
	}

	public function followSlotClient( itemSlot : ItemSlot ) {
		this.itemSlot = itemSlot;
		binder.add(
			itemReplicator.addOnValueImmediately(
				( oldItem, newItem ) -> {
					if ( newItem == null ) {
						itemSlot.removeItem();
					} else {
						newItem.item.then( ( item ) -> itemSlot.giveItem( item ) );
					}
				}
			)
		);
	}

	function addOnItem( cb : ( oldItem : Item, item : Item ) -> Void ) {
		binder.add( itemSlot.itemProp.addOnValueImmediately( cb ) );
	}

	function onItemChanged( oldItem : Item, item : Item ) {
		if ( oldItem != null && !oldItem.disposed.isTriggered ) {
			var itemReplicator = CoreReplicator.inst.getItemReplicator( oldItem );
			removeChild( itemReplicator );
		}
		if ( item == null ) {
			itemReplicator.val = null;
			return;
		}

		itemReplicator.val = CoreReplicator.inst.getItemReplicator( item );
		addChild( itemReplicator );
	}

	override function alive() {
		super.alive();
	}
}
