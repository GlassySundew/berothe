package game.net.item;

import game.net.CoreReplicator;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;
import net.NetNode;

class ItemSlotReplicator extends NetNode {

	final itemSlot : ItemSlot;

	public function new( itemSlot : ItemSlot, ?parent ) {
		super( parent );

		this.itemSlot = itemSlot;
		itemSlot.itemProp.addOnValueImmediately( onItemChanged );
	}

	function onItemChanged( oldItem : Item, item : Item ) {
		if ( oldItem != null ) {
			var itemReplicator = CoreReplicator.inst.getItemReplicator( oldItem );
			removeChild( itemReplicator );
		}

		var itemReplicator = CoreReplicator.inst.getItemReplicator( item );
		addChild( itemReplicator );
	}
}
