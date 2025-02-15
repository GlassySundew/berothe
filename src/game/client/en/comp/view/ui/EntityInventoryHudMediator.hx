package game.client.en.comp.view.ui;

import h2d.Object;
import rx.disposables.Composite;
import game.domain.overworld.item.model.ItemSlot;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.entity.component.model.EntityInventory;
import game.domain.overworld.entity.component.model.EntityModelComponent;

class EntityInventoryHudMediator {

	public final subscription = Composite.create();

	final inventory : EntityInventory;
	final view : EntityInventoryHudViewMediator;

	public var inventorySlots : Array<ItemSlot>;

	public function new(
		inventory : EntityInventory,
		parent : Object
	) {
		this.inventory = inventory;

		setupSlots();

		view = new EntityInventoryHudViewMediator( this, parent );
	}

	public function dispose() {
		view.comp.remove();
		subscription.unsubscribe();
	}

	function setupSlots() {
		inventorySlots = [];

		for ( slot in inventory.inventorySlots ) {
			// todo is a better way to do so
			if ( slot is EquipItemSlot ) continue;
			if ( slot.restriction.types.contains( GOLD ) ) continue;

			inventorySlots.push( slot );
		}
	}
}
