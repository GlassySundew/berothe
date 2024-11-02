package game.domain.overworld.entity.component.model;

import future.Future;
import signals.Signal;
import game.domain.overworld.entity.component.combat.EntityDamageType;
import game.domain.overworld.entity.component.model.stat.EntitySpeedStat;
import game.data.storage.DataStorage;
import game.data.storage.faction.FactionDescription;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import core.MutableProperty;
import core.DispArray;

class EntityModelComponent extends EntityComponent {

	public final inventory : EntityInventory;
	public final stats : EntityStats;
	public final factions : DispArray<FactionDescription>;
	public final hp : MutableProperty<Int> = new MutableProperty( 1 );
	public final onDamaged = new Signal<Int, EntityDamageType>();
	public final isSleeping : MutableProperty<Null<Bool>> = new MutableProperty();
	public final displayName = new MutableProperty<String>();
	public final onDeath : Future<Bool> = new Future();

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

		if ( desc.baseHp != 0 ) hp.val = desc.baseHp;
		hp.addOnValueImmediately( onHpChanged );

		if ( desc.displayName != null ) displayName.val = desc.displayName;
	}

	public function tryGiveItem( item : Item ) : ItemPickupAttemptResult {
		return inventory.tryGiveItem( item );
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

	public function hasEnemy() {
		for ( faction in factions ) {
			if ( faction.hostileFactions.get().length > 0 ) {
				return true;
				break;
			}
		}
		return false;
	}

	public function getDamagedWith( damage : Int, type : EntityDamageType ) {
		hp.val -= damage;
		onDamaged.dispatch( damage, type );
	}

	override function claimOwnage() {
		super.claimOwnage();
		inventory.claimOwnage();
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		stats.attachToEntity( entity );
	}

	function onHpChanged( oldVal : Int, newVal : Int ) {
		if ( newVal <= 0 ) {
			onDeath.resolve( true );
			entity.dispose();
		}
	}
}
