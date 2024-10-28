package game.domain.overworld.entity.component.model;

import haxe.exceptions.NotImplementedException;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.data.storage.entity.body.model.EntityModelDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;
import game.domain.overworld.entity.component.model.stat.EntityAttackStat;
import game.domain.overworld.entity.component.model.stat.EntityWeaponRangeStat;
import game.domain.overworld.item.model.EquipItemSlot;

class EntityStats {

	public final modelDesc : EntityModelDescription;

	public final limbAttacks : Array<EntityLimbedStatHolder> = [];
	public final weaponRanges : Array<EntityLimbedStatHolder> = [];

	// todo
	// public final defence
	// public final hp
	var entity( default, null ) : OverworldEntity;

	public function new( modelDesc : EntityModelDescription ) {
		this.modelDesc = modelDesc;
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		createAttackStat();
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
				case DEFENCE: throw new NotImplementedException();
				case SPEED: throw new NotImplementedException();
				case WEAPON_RANGE:
					addAttackLimbStat( stat, weaponRanges, slot );
			}
		}
	}

	function createAttackStat() {
		for ( desc in entity.desc.getBodyDescription().attackDesc.attackList ) {
			var holder = new EntityLimbedStatHolder( desc.equipSlotType );
			limbAttacks.push( holder );
			holder.addStat( new EntityAttackStat( desc.baseAttack ) );

			var holder = new EntityLimbedStatHolder( desc.equipSlotType );
			weaponRanges.push( holder );
			holder.addStat( new EntityAttackStat( desc.endX ) );
		}
	}

	inline function addAttackLimbStat(
		stat : EntityAdditiveStatBase,
		statHolders : Array<EntityLimbedStatHolder>,
		?slot : EquipItemSlot
	) {
		if ( slot == null ) {
			// add attack to all attack limbs
			for ( attack in statHolders ) {
				attack.addStat( stat );
			}
		} else if ( slot != null ) {
			var limbedStat = statHolders.filter( statHolder -> statHolder.limb == slot.desc.type )[0];

			if ( limbedStat != null ) {
				limbedStat.addStat( stat );
			} else {
				var linkedSlots = getLinkedSlots( slot.desc, statHolders );
				for ( linkedSlot in linkedSlots ) {
					linkedSlot.addStat(stat);
				}
			}
		}
	}

	inline function getLinkedSlots(
		slotDesc : EntityEquipSlotDescription,
		statHolders : Array<EntityLimbedStatHolder>
	) : Array<EntityLimbedStatHolder> {
		var linkedStats = statHolders.filter( statHolder -> slotDesc.links.contains( statHolder.limb ) );

		return linkedStats;
	}
}
