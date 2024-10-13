package game.net.entity.component.model;

import game.domain.overworld.item.Item;
import net.NSIntMap;
import util.Assert;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.item.EquipSlotReplicator;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.net.item.ItemReplicator;
import rx.disposables.Boolean;
import rx.disposables.Composite;
import game.net.item.ItemSlotReplicator;
import net.NSArray;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.domain.overworld.entity.component.model.EntityInventory;
import net.NetNode;
#if client
import game.client.item.ItemEquipView;
#end

class EntityEquipReplicator extends NetNode {

	var entityEquip : EntityInventory;

	var entityRepl : EntityReplicator;
	@:s var slots : NSIntMap<EquipSlotReplicator> = new NSIntMap();

	public function new(
		entityEquip : EntityInventory,
		entityRepl : EntityReplicator,
		?parent
	) {
		super( parent );
		this.entityEquip = entityEquip;
		this.entityRepl = entityRepl;

		initializeSlots();
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		slots.unregister( host, ctx );
	}

	// server-only
	function initializeSlots() {
		for ( slotType => slot in entityEquip.equipSlots ) {
			var slotRepl = new EquipSlotReplicator( slotType, slot, this );
			slots[slotType] = slotRepl;
		}
	}

	#if client
	public function followClient(
		entityEquip : EntityInventory,
		entityRepl : EntityReplicator
	) {
		this.entityEquip = entityEquip;
		this.entityRepl = entityRepl;

		for ( key => slot in slots.keyValueIterator() ) {
			slot.followSlotClient( entityEquip.equipSlots[key] );
		}

		for ( equipSlotType => slot in entityEquip.equipSlots ) {
			slot.itemProp.addOnValueImmediately(
				equipSlotItemChanged.bind( _, _, equipSlotType )
			);
		}
	}

	function equipSlotItemChanged(
		oldItem : Item,
		item : Item,
		type : EntityEquipmentSlotType
	) {
		if ( item == null ) return;

		var viewComp = entityRepl.entity.result.components.get( EntityViewComponent );
		Assert.notNull( viewComp );

		new ItemEquipView( item, type, viewComp );
	}
	#end
}
