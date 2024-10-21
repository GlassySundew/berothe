package game.domain.overworld.entity.component.model;

import game.data.storage.DataStorage;
import game.data.storage.faction.FactionDescription;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import core.MutableProperty;
import core.DispArray;

class EntityModelComponent extends EntityComponent {

	public final hp : MutableProperty<Float> = new MutableProperty( 1. );
	public final inventory : EntityInventory;
	public final stats : EntityStats;
	public final factions : DispArray<FactionDescription>;

	final desc : EntityModelDescription;

	public function new( desc : EntityModelDescription ) {
		super( desc );
		this.desc = desc;

		inventory = new EntityInventory( this, desc.baseInventorySize, desc.equipSlots );
		stats = new EntityStats( desc );
		factions = new DispArray();
		factions.push( DataStorage.inst.factionStorage.getById( desc.factionId ) );
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
