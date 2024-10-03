package game.domain.overworld.entity.component.model;

import game.domain.overworld.entity.component.model.stat.EntityWeaponRangeStat;
import haxe.exceptions.NotImplementedException;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.domain.overworld.item.model.EquipItemSlot;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;
import game.domain.overworld.entity.component.model.stat.EntityAttackStat;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.model.EntityModelDescription;

class EntityStats {

	public final modelDesc : EntityModelDescription;

	public final limbAttacks : Map<EntityEquipmentSlotType, EntityStatHolder> = [];
	public final weaponRanges : Map<EntityEquipmentSlotType, EntityStatHolder> = [];

	// todo
	// public final defence
	// public final hp
	var entity( default, null ) : OverworldEntity;

	public function new( modelDesc : EntityModelDescription ) {
		this.modelDesc = modelDesc;
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		// entity.desc.getBodyDescription().attackDesc
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
				case WEAPON_RANGE:
					addAttackLimbStat( stat, weaponRanges, slot );
			}
		}
	}

	function createAttackStat() {
		for ( desc in entity.desc.getBodyDescription().attackDesc.attackList ) {
			var holder = new EntityStatHolder();
			limbAttacks[desc.equipSlotType] = holder;
			var baseAttackModel = modelDesc.baseAttacks.filter(
				item -> item.attackId == desc.id
			)[0];
			holder.addStat( new EntityAttackStat( baseAttackModel.amount ) );

			var holder = new EntityStatHolder();
			weaponRanges[desc.equipSlotType] = holder;
			holder.addStat( new EntityAttackStat( desc.endX ) );
		}
	}

	inline function addAttackLimbStat(
		stat : EntityAdditiveStatBase,
		statMap : Map<EntityEquipmentSlotType, EntityStatHolder>,
		?slot : EquipItemSlot
	) {
		if ( slot == null ) {
			// add attack to all attack limbs
			for ( attack in statMap ) {
				attack.addStat( stat );
			}
		} else {
			if ( statMap.exists( slot.desc.type ) ) {
				statMap[slot.desc.type].addStat( stat );
			} else {
				var linkedSlot = getLinkedSlot( slot.desc );
				if ( linkedSlot == null ) {
					trace( "bad logic, slot " + slot.desc.type + " is not a valid attack stat key" );
				} else {
					statMap[linkedSlot].addStat( stat );
				}
			}
		}
	}

	inline function getLinkedSlot(
		slotDesc : EntityEquipSlotDescription
	) : Null<EntityEquipmentSlotType> {
		var result = null;
		for ( link in slotDesc.links ) {
			if ( limbAttacks.exists( link ) ) {
				result = link;
				break;
			}
		}
		return result;
	}
}
