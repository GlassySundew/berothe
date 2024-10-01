package game.domain.overworld.entity.component.model;

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
				case ATTACK: addAttackStat( Std.downcast( stat, EntityAttackStat ), slot );
				case DEFENCE: throw new NotImplementedException();
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
		}
	}

	inline function addAttackStat(
		attStat : EntityAttackStat,
		?slot : EquipItemSlot
	) {
		if ( slot == null ) {
			// add attack to all attack limbs
			for ( attack in limbAttacks ) {
				attack.addStat( attStat );
			}
		} else {
			if ( limbAttacks.exists( slot.desc.type ) ) {
				limbAttacks[slot.desc.type].addStat( attStat );
			} else {
				var linkedSlot = getLinkedSlot( slot.desc );
				if ( linkedSlot == null ) {
					trace( "bad logic, slot " + slot.desc.type + " is not a valid attack stat key" );
				} else {
					limbAttacks[linkedSlot].addStat( attStat );
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
