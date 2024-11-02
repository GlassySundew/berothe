package game.client.en.comp.view.ui;

import game.domain.overworld.item.model.ItemSlot;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.entity.component.model.EntityInventory;
import game.domain.overworld.entity.component.model.EntityModelComponent;

class EntityInventoryHudMediator {

	final inventory : EntityInventory;
	final view : EntityInventoryHudViewMediator;

	public var inventorySlots : Array<ItemSlot>;

	public function new( inventory : EntityInventory ) {
		this.inventory = inventory;

		setupSlots();

		view = new EntityInventoryHudViewMediator( this );
		Main.inst.root.add( view.comp, util.Const.DP_UI );
	}

	function setupSlots() {
		inventorySlots = [];

		for ( slot in inventory.inventorySlots ) {
			// todo temp
			if ( slot is EquipItemSlot ) continue;
			if ( slot.restriction.types.contains( GOLD ) ) continue;

			inventorySlots.push( slot );
		}
	}
}
