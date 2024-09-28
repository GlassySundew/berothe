package game.net.entity.component.model;

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
import game.domain.overworld.entity.component.model.EntityEquip;
import net.NetNode;

#if client
import game.client.item.ItemEquipView;
#end

class EntityEquipReplicator extends NetNode {

	@:s final entityRepl : EntityReplicator;

	final entityEquip : EntityEquip;

	@:s var slots : NSArray<EquipSlotReplicator> = new NSArray();

	public function new(
		entityEquip : EntityEquip,
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

	#if client
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

		var viewComp = entityRepl.entity.result.components.get( EntityViewComponent );
		Assert.notNull( viewComp );

		itemRepl.item.then( ( item ) -> {
			new ItemEquipView( item, type, viewComp );
		} );
	}
	#end
}
