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

	public final itemSlot : ItemSlot;
	final binder : Composite;

	@:s final itemReplicator : NSMutableProperty<ItemReplicator>;
	public var itemReplicatorProp( get, default ) : IProperty<ItemReplicator>;
	inline function get_itemReplicatorProp() {
		return itemReplicator;
	}

	public function new( itemSlot : ItemSlot, ?parent ) {
		super( parent );

		itemReplicator = new NSMutableProperty( null, this );
		binder = new Composite();
		this.itemSlot = itemSlot;

		addOnItem( onItemChanged );
	}

	function addOnItem( cb : ( oldItem : Item, item : Item ) -> Void ) {
		binder.add( itemSlot.itemProp.addOnValueImmediately( cb ) );
	}

	function onItemChanged( oldItem : Item, item : Item ) {
		if ( oldItem != null ) {
			var itemReplicator = CoreReplicator.inst.getItemReplicator( oldItem );
			removeChild( itemReplicator );
		}
		if ( item == null ) return;

		itemReplicator.val = CoreReplicator.inst.getItemReplicator( item );
		addChild( itemReplicator );
	}

	override function alive() {
		super.alive();
	}
}
