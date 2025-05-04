package game.domain.overworld.entity.component.model;

import game.data.storage.DataStorage;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;
import game.domain.overworld.entity.component.model.stat.EntityAttackStat;
import game.domain.overworld.entity.component.model.stat.EntityDefenceStat;
import game.domain.overworld.entity.component.model.stat.EntityHPRegenStat;
import game.domain.overworld.entity.component.model.stat.EntityMaxHpStat;
import game.domain.overworld.entity.component.model.stat.EntitySpeedStat;
import game.domain.overworld.item.model.EquipItemSlot;

class EntityStats {

	public final modelDesc : EntityModelDescription;

	public final limbAttacks : Array<EntityAttkItemStatHolder> = [];
	public final weaponRanges : Array<EntityAttkItemStatHolder> = [];
	public final speed : EntityStatHolder = new EntityStatHolder();
	public final defence : EntityStatHolder = new EntityStatHolder();
	public final maxHp : EntityStatHolder = new EntityStatHolder();

	/** per second **/
	public final hpRegen : EntityStatHolder = new EntityStatHolder();

	// todo
	// public final hp
	var entity( default, null ) : OverworldEntity;

	public function new( modelDesc : EntityModelDescription ) {
		this.modelDesc = modelDesc;
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		createAttackStat();

		if ( modelDesc.baseSpeed != 0 ) {
			speed.addStat( new EntitySpeedStat( modelDesc.baseSpeed ) );
		}

		if ( modelDesc.baseDefence != 0 ) {
			defence.addStat( new EntityDefenceStat( modelDesc.baseDefence ) );
		}

		if ( modelDesc.baseHp != 0 ) {
			maxHp.addStat( new EntityMaxHpStat( modelDesc.baseHp ) );
		}

		hpRegen.addStat( new EntityHPRegenStat( DataStorage.inst.rule.baseHpRegenPerSecond ) );
	}

	/**
		@param slot 
			if present, will be used by those stats that require equipment slot;
			attack stats that are added without slot will be added to all attack
			handles
	**/
	public function addStats(
		stats : Array<EntityAdditiveStatBase>,
		?slot : EquipItemSlot
	) {
		for ( stat in stats ) {
			switch stat.type {
				case ATTACK:
					addAttackLimbStat( stat, limbAttacks, slot );
				case WEAPON_RANGE:
					addAttackLimbStat( stat, weaponRanges, slot );
				case DEFENCE:
					defence.addStat( stat );
				case SPEED:
					speed.addStat( stat );
				case MAX_HP:
					maxHp.addStat( stat );
				case HP_REGEN:
					hpRegen.addStat( stat );
			}
		}
	}

	function createAttackStat() {
		var attkList = entity.desc.getBodyDescription().attackDesc?.attackList;
		if ( attkList == null ) return;
		for ( desc in entity.desc.getBodyDescription().attackDesc.attackList ) {
			var holder = new EntityAttkItemStatHolder( desc );
			limbAttacks.push( holder );
			holder.addStat( new EntityAttackStat( desc.baseAttack ) );

			var holder = new EntityAttkItemStatHolder( desc );
			weaponRanges.push( holder );
			holder.addStat( new EntityAttackStat( desc.endX ) );
		}
	}

	inline function addAttackLimbStat(
		stat : EntityAdditiveStatBase,
		statHolders : Array<EntityAttkItemStatHolder>,
		?slot : EquipItemSlot
	) {
		if ( slot == null ) {
			// add attack to all attack limbs
			for ( attack in statHolders ) {
				attack.addStat( stat );
			}
		} else if ( slot != null ) {
			var limbedStat = statHolders.filter( statHolder -> statHolder.desc.equipSlotType == slot.desc.type )[0];

			if ( limbedStat != null ) {
				limbedStat.addStat( stat );
			} else {
				var linkedSlots = getLinkedSlots( slot.desc, statHolders );
				for ( linkedSlot in linkedSlots ) {
					linkedSlot.addStat( stat );
				}
			}
		}
	}

	inline function getLinkedSlots(
		slotDesc : EntityEquipSlotDescription,
		statHolders : Array<EntityAttkItemStatHolder>
	) : Array<EntityAttkItemStatHolder> {
		var linkedStats = statHolders.filter(
			statHolder -> slotDesc.links.contains( statHolder.desc.equipSlotType )
		);

		return linkedStats;
	}
}
