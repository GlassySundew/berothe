package game.net.entity.component.model;

import net.NSArray;
import hxbit.NetworkSerializable.NetworkSerializer;
import hxbit.NetworkHost;
import game.net.item.ItemSlotReplicator;
import net.NSIntMap;
import game.domain.overworld.entity.component.model.EntityInventory;
import net.NetNode;

class EntityInventoryReplicator extends NetNode {

	var entityInventory( default, null ) : EntityInventory;

	@:s var slots : NSArray<ItemSlotReplicator> = new NSArray();

	public function new(
		entityInventory : EntityInventory,
		?parent
	) {
		super( parent );
		this.entityInventory = entityInventory;

		initializeSlots();
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		slots.unregister( host, ctx );
	}

	// server-only
	function initializeSlots() {
		for ( slot in entityInventory.inventorySlots ) {
			var slotRepl = new ItemSlotReplicator( slot, this );
			slots.push( slotRepl );
		}
	}

	#if client
	public function followClient(
		entityInventory : EntityInventory
	) {
		this.entityInventory = entityInventory;

		for ( i => slot in slots.keyValueIterator() ) {
			if ( slot is EntityEquipReplicator ) continue;
			slot.followSlotClient( entityInventory.inventorySlots[i] );
		}
	}
	#end
}
