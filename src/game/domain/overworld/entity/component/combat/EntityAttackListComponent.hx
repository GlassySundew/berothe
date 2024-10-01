package game.domain.overworld.entity.component.combat;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.view.AnimationKey;

class EntityAttackListComponent extends EntityComponent {

	public final attackListDesc : AttackListDescription;
	public final attackComponents : Array<EntityAttackListItem>;

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

	public inline function getItemByEquipSlotType( type : EntityEquipmentSlotType ) : Null<EntityAttackListItem> {
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
		var result = [
			for ( attackDesc in attackListDesc.attackList ) {
				new EntityAttackListItem( attackDesc );
			}
		];

		return result;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		for ( component in attackComponents ) {
			component.attachToEntity( entity );
		}
	}
}
