package game.domain.overworld.entity.component.combat;

import game.data.storage.entity.body.properties.AttackListItemVO;
import util.Assert;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import be.Constant;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.view.AnimationKey;

class EntityAttackListComponent extends EntityComponent {

	public final attackListDesc : AttackListDescription;
	public final attacksList : Array<EntityAttackListItem>;

	public var leadingAttack( default, null ) : EntityEquipmentSlotType;

	public function new( description : AttackListDescription ) {
		super( description );
		this.attackListDesc = description;

		attacksList = createAttackList();
	}

	public function attack() {
		for ( attackComponent in attacksList ) {
			attackComponent.attack();
		}
	}

	public function getItemByAnimationKey( key : AnimationKey ) {
		for ( listItem in attacksList ) {
			if ( listItem.desc.key == key ) return listItem;
		}
		return null;
	}

	public inline function getItemByItemDescId( id : String ) : Null<EntityAttackListItem> {
		var result = null;
		for ( listItem in attacksList ) {
			if ( listItem.desc.id == id ) {
				result = listItem;
				break;
			}
		}
		return result;
	}

	public inline function getItemByDesc(
		desc : AttackListItemVO
	) : Null<EntityAttackListItem> {
		var result = null;
		for ( listItem in attacksList ) {
			if ( listItem.desc == desc ) {
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

		for ( component in attacksList ) {
			component.attachToEntity( entity );
		}

		entity.components.onAppear(
			EntityModelComponent,
			( _, modelCompRepl ) -> {
				var weaponRanges = modelCompRepl.stats.weaponRanges;

				Assert.isTrue( weaponRanges.length > 0 );

				for ( weaponRangeStatHolder in weaponRanges ) {
					var attackItem = getItemByDesc( weaponRangeStatHolder.desc );
					Assert.notNull( attackItem );
					weaponRangeStatHolder.amount.addOnValueImmediately(
						( _, val ) -> attackItem.setRange( val )
					);
				}
			}
		);
	}

	override function claimOwnage() {
		super.claimOwnage();
		for ( item in attacksList ) {
			item.claimOwnage();
		}
	}
}
