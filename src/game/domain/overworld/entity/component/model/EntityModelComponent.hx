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
	public final onDeathSignal : Future<Bool> = new Future();
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

	#if !debug inline #end;
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

	public function provideMsgVO( msgVO : EntityMessageVO, timeoutS = 5 ) {
		statusMessages.push( msgVO );
		entity.delayer.addS(() -> statusMessages.remove( msgVO ), timeoutS );
	}

	public function sayText( text : String ) {
		var msgVO = EntityMessageVO.speech( text );
		provideMsgVO( msgVO );
	}

	public function getDamagedWith( damage : Int, type : EntityDamageType ) {
		var damageSpeech : String = Random.fromArray( desc.speechDamaged );
		if ( damageSpeech == null ) damageSpeech = "";
		// todo replace parentheses with those of corresponding damage type
		damageSpeech += ' ($damage)';
		var msgVO = EntityMessageVO.damageTaken( damageSpeech );
		provideMsgVO( msgVO, 3 );

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
		if ( desc.factionId != null )
			factions.push( DataStorage.inst.factionStorage.getById( desc.factionId ) );

		if ( desc.baseHp != 0 ) hp.val = desc.baseHp;

		if ( desc.displayName != null ) displayName.val = desc.displayName;
	}

	function onHpChanged( oldVal : Int, newVal : Int ) {
		if ( newVal <= 0 ) {
			onDeath();
			entity.dispose();
		}
	}

	function onDeath() {
		var deathEntityDesc = DataStorage.inst.entityStorage.getById(
			DataStorage.inst.rule.deathMessageEntity
		);
		var location = entity.location.getValue();
		var deathPointEntity = location.entityFactory.createEntity( deathEntityDesc );
		var deathComp = deathPointEntity.components.get( EntityDeathMessageComponent );
		deathComp.providePrecedingEntity( this.entity );
		deathPointEntity.transform.setPosition(
			entity.transform.x,
			entity.transform.y,
			entity.transform.z
		);
		location.addEntity( deathPointEntity );

		onDeathSignal.resolve( true );
	}
}
