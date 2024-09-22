package game.net.entity.component.model;

import game.net.item.EquipSlotReplicator;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.net.item.ItemReplicator;
import rx.disposables.Boolean;
import rx.disposables.Composite;
import game.net.item.ItemSlotReplicator;
import net.NSArray;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.domain.overworld.entity.component.model.EntityEquip;
import net.NetNode;

class EntityEquipReplicator extends NetNode {

	final entityEquip : EntityEquip;

	@:s var slots : NSArray<EquipSlotReplicator> = new NSArray();

	public function new( entityEquip : EntityEquip, ?parent ) {
		super( parent );
		this.entityEquip = entityEquip;

		initializeSlots();
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
	}

	// server-only
	function initializeSlots() {
		for ( slotType => slot in entityEquip.equipSlots ) {
			var slotRepl = new EquipSlotReplicator( slotType, slot, this );
			// not sure if I need this
			// slotRepl.itemReplicatorProp.addOnValueImmediately(
			// 	equipSlotItemChanged.bind( _, _, slotType )
			// );
			slots.push( slotRepl );
		}
	}

	override function alive() {
		super.alive();
		slots.subscribleWithMapping( ( elem ) -> {
			elem.itemReplicatorProp.addOnValueImmediately(
				equipSlotItemChanged.bind( _, _, elem.slotType )
			);
		} );
	}

	function equipSlotItemChanged(
		oldItemRepl,
		itemRepl : ItemReplicator,
		type : EntityEquipmentSlotType
	) {
		if ( itemRepl == null ) return;
		trace( "item repl change detected" );

		
	}
}
