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
	public final isSleeping : MutableProperty<Null<Bool>> = new MutableProperty();
	public final displayName = new MutableProperty<String>();

	public var desc( get, never ) : EntityModelDescription;
	inline function get_desc() : EntityModelDescription {
		return Std.downcast( description, EntityModelDescription );
	}

	public function new( desc : EntityModelDescription ) {
		super( desc );

		inventory = new EntityInventory( this, desc.baseInventorySize, desc.equipSlots );
		stats = new EntityStats( desc );
		factions = new DispArray();
		factions.push( DataStorage.inst.factionStorage.getById( desc.factionId ) );

		if ( desc.displayName != null ) displayName.val = desc.displayName;
	}

	public function tryPickupItem( item : Item ) : ItemPickupAttemptResult {
		return inventory.tryPickupItem( item );
	}

	public function hasSpaceForItemDesc( itemDesc : ItemDescription, amount = 1 ) : Bool {
		if ( inventory.hasSpaceForItem( itemDesc, amount ) ) return true;

		return false;
	}

	public function sleep() {
		isSleeping.val = true;
	}

	public function wake() {
		isSleeping.val = false;
	}

	public function isEnemy( enemyMaybe : OverworldEntity ) : Bool {
		var enemyMaybeModel = enemyMaybe.components.get( EntityModelComponent );
		if ( enemyMaybeModel == null ) return false;

		for ( faction in factions.iterator() ) {
			for ( enemyFaction in enemyMaybeModel.factions.iterator() ) {
				if ( faction.hostileFactions.get().contains( enemyFaction ) ) return true;
			}
		}

		return false;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		stats.attachToEntity( entity );
	}
}
