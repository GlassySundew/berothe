package game.domain.overworld.entity.component.model;

import game.client.en.comp.view.EntityMessageVO;
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

	public final hp : MutableProperty<Int> = new MutableProperty( 1 );
	public final isSleeping : MutableProperty<Null<Bool>> = new MutableProperty();
	public final onDeath : Future<Bool> = new Future();
	public final onDamaged = new Signal<Int, EntityDamageType>();
	public final displayName = new MutableProperty<String>();
	public final statusMessages : DispArray<EntityMessageVO> = new DispArray<EntityMessageVO>();

	public var inventory( default, null ) : EntityInventory;
	public var stats( default, null ) : EntityStats;
	public var factions( default, null ) : DispArray<FactionDescription>;

	public var desc( get, never ) : EntityModelDescription;
	inline function get_desc() : EntityModelDescription {
		return Std.downcast( description, EntityModelDescription );
	}

	public function new( desc : EntityModelDescription ) {
		super( desc );
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

	public function sayText( text : String ) {
		var mesVO = EntityMessageVO.speech( text );
		statusMessages.push( mesVO );
		entity.delayer.addS(() -> statusMessages.remove( mesVO ), 5 );
	}

	public function getDamagedWith( damage : Int, type : EntityDamageType ) {
		var damageSpeech : String = Random.fromArray( desc.speechDamaged );
		if ( damageSpeech == null ) damageSpeech = "";
		// todo replace parentheses with those of corresponding damage type
		damageSpeech += ' ($damage)';
		var mesVO = EntityMessageVO.damageTaken( damageSpeech );
		statusMessages.push( mesVO );
		entity.delayer.addS(() -> statusMessages.remove( mesVO ), 3 );

		hp.val -= damage;
		onDamaged.dispatch( damage, type );
	}

	override function claimOwnage() {
		super.claimOwnage();
		hp.addOnValueImmediately( onHpChanged );
		inventory.claimOwnage();
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		inventory = new EntityInventory( this, desc.baseInventorySize, desc.equipSlots );
		stats = new EntityStats( desc );
		stats.attachToEntity( entity );

		factions = new DispArray();
		factions.push( DataStorage.inst.factionStorage.getById( desc.factionId ) );

		if ( desc.baseHp != 0 ) hp.val = desc.baseHp;

		if ( desc.displayName != null ) displayName.val = desc.displayName;
	}

	function onHpChanged( oldVal : Int, newVal : Int ) {
		if ( newVal <= 0 ) {
			onDeath.resolve( true );
			entity.dispose();
		}
	}
}
