package game.client.en.comp.view.ui;

import rx.disposables.Composite;
import dn.heaps.slib.HSprite;
import util.Assets;
import game.domain.overworld.item.model.ItemSlot;
import h2d.Flow;
import h2d.Object;
import ui.CustomFlow;

class EntityInventoryHudViewMediator {

	final mediator : EntityInventoryHudMediator;
	public final comp : EntityInventoryHudComp;

	public function new(
		mediator : EntityInventoryHudMediator,
		?parent : Object
	) {
		this.mediator = mediator;

		comp = new EntityInventoryHudComp( parent );

		// todo sash

		var slotsReverse = mediator.inventorySlots.copy();
		slotsReverse.reverse();

		for ( slot in slotsReverse ) {
			var slotView = new EntityInventoryCellComp( slot, mediator.subscription );
			comp.inventory_container.addChild( slotView );
		}
	}
}

class EntityInventoryHudComp extends CustomFlow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<entity-inventory-hud-comp >
			<flow 
				margin = "10" 
				public id = "inventory_container"
				valign = "bottom"
				halign = "right"
				layout = "vertical"
			>

			</flow>

		</entity-inventory-hud-comp>
		
	// @formatter:on
	//
	public function new(
		?parent : Object
	) {
		super( parent );
		initComponent();
		customFillHeight = true;
		customFillWidth = true;
	}
}

class EntityInventoryCellComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<entity-inventory-cell-comp 
			min-width = "35"
			min-height = "35"
		>

		</entity-inventory-cell-comp>
	
	// @formatter:on
	//
	final itemSlot : ItemSlot;

	public function new(
		itemSlot : ItemSlot,
		composite : Composite,
		?parent : Object
	) {
		super( parent );
		this.itemSlot = itemSlot;
		initComponent();

		composite.add( itemSlot.itemProp.addOnValueImmediately(
			( oldItem, newItem ) -> {
				removeChildren();

				if ( newItem == null ) return;

				addChild( new HSprite( Assets.items, newItem.desc.iconAsset ) );
			}
		) );
	}
}
