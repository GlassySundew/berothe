package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import core.MutableProperty;

class EntityModelComponent extends EntityComponent {

	public final hp : MutableProperty<Float> = new MutableProperty( 1. );

	public final inventory : EntityInventory;
	public final stats : EntityStats;

	final desc : EntityModelDescription;

	public function new( desc : EntityModelDescription ) {
		super( desc );
		this.desc = desc;

		inventory = new EntityInventory( this, desc.baseInventorySize, desc.equipSlots );
		stats = new EntityStats( desc );
	}

	public function tryPickupItem( item : Item ) : ItemPickupAttemptResult {
		return inventory.tryPickupItem( item );
	}

	public function hasSpaceForItemDesc( itemDesc : ItemDescription, amount = 1 ) : Bool {
		if ( inventory.hasSpaceForItem( itemDesc, amount ) ) return true;

		return false;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		stats.attachToEntity( entity );
	}
}
