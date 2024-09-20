package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import core.MutableProperty;

class EntityModelComponent extends EntityComponent {

	public final hp : MutableProperty<Float> = new MutableProperty( 1. );

	public final inventory : EntityInventory;
	public final equip : EntityEquip;

	final desc : EntityModelDescription;

	public function new( desc : EntityModelDescription ) {
		super( desc );
		this.desc = desc;

		equip = new EntityEquip( desc.equipSlots );
		inventory = new EntityInventory( desc.baseInventorySize );
	}

	public function tryPickupItem( item : Item ) : ItemPickupAttemptResult {
		var result = equip.tryPickupItem( item );
		if ( result.status == SUCCESS ) return result;

		result = inventory.tryPickupItem( item );
		return result;
	}

	public function hasSpaceForItemDesc( itemDesc : ItemDescription, amount = 1 ) : Bool {
		if ( equip.hasSpaceForItem( itemDesc, amount ) ) return true;
		if ( inventory.hasSpaceForItem( itemDesc, amount ) ) return true;

		return false;
	}
}
