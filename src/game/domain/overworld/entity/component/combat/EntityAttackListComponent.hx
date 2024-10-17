package game.domain.overworld.entity.component.combat;

import util.Assert;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import be.Constant;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.view.AnimationKey;

class EntityAttackListComponent extends EntityComponent {

	public final attackListDesc : AttackListDescription;
	public final attackComponents : Array<EntityAttackListItem>;

	public var leadingAttack( default, null ) : EntityEquipmentSlotType;

	public function new( description : AttackListDescription ) {
		super( description );
		this.attackListDesc = description;

		attackComponents = createAttackList();
	}

	public function attack() {
		for ( attackComponent in attackComponents ) {
			attackComponent.attack();
		}
	}

	public function getItemByAnimationKey( key : AnimationKey ) {
		for ( listItem in attackComponents ) {
			if ( listItem.desc.key == key ) return listItem;
		}
		return null;
	}

	public inline function getItemByItemDescId( id : String ) : Null<EntityAttackListItem> {
		var result = null;
		for ( listItem in attackComponents ) {
			if ( listItem.desc.id == id ) {
				result = listItem;
				break;
			}
		}
		return result;
	}

	public inline function getItemByEquipSlotType(
		type : EntityEquipmentSlotType
	) : Null<EntityAttackListItem> {
		var result = null;
		for ( listItem in attackComponents ) {
			if ( listItem.desc.equipSlotType == type ) {
				result = listItem;
				break;
			}
		}
		return result;
	}

	function createAttackList() : Array<EntityAttackListItem> {
		var leadingEquip = null;
		var lowestCD = Floats.MAX;
		var result = [
			for ( attackItem in attackListDesc.attackList ) {
				if ( attackItem.cooldown < lowestCD ) {
					leadingEquip = attackItem.equipSlotType;
					lowestCD = attackItem.cooldown;
				}
				new EntityAttackListItem( attackItem );
			}
		];
		leadingAttack = leadingEquip;

		result.sort(
			( item1, item2 ) -> Reflect.compare( item1.desc.cooldown, item2.desc.cooldown )
		);

		return result;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		for ( component in attackComponents ) {
			component.attachToEntity( entity );
		}

		entity.components.onAppear(
			EntityModelComponent,
			( _, modelCompRepl ) -> {
				var attackMap = modelCompRepl.stats.limbAttacks;
				for ( attackStatHolder in attackMap ) {
					if ( attackStatHolder.limb == null ) continue;
					var attackItem = getItemByEquipSlotType( attackStatHolder.limb );
					Assert.notNull( attackItem );
					attackStatHolder.amount.addOnValue(
						( _, val ) -> attackItem.setAttack( val )
					);
				}
				var weaponRanges = modelCompRepl.stats.weaponRanges;
				for ( weaponRangeStatHolder in weaponRanges ) {
					if ( weaponRangeStatHolder.limb == null ) continue;
					var attackItem = getItemByEquipSlotType( weaponRangeStatHolder.limb );
					Assert.notNull( attackItem );
					weaponRangeStatHolder.amount.addOnValueImmediately(
						( _, val ) -> attackItem.setRange( val )
					);
				}
			}
		);
	}
}
