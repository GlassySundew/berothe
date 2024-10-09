package game.data.storage.entity.body.model;

import game.net.entity.component.EntitySimpleComponentReplicator;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntityModelComponentReplicator;

typedef EntityBaseAttackItem = {
	amount : Int,
	attackId : String
}

class EntityModelDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_model
	) : EntityModelDescription {
		if ( entry == null ) return null;

		var equipSlots = [
			for ( equipSlot in entry.equipment ) {
				new EntityEquipSlotDescription(
					EntityEquipmentSlotType.fromCdb( equipSlot.type ),
					equipSlot.priority,
					[
						for ( link in equipSlot.links )
							EntityEquipmentSlotType.fromCdb( link.type )
					]
				);
			}
		];

		var baseAttacks : Array<EntityBaseAttackItem> = [
			for ( baseAttackElem in entry.baseAttack ) {
				{
					amount : baseAttackElem.amount,
					attackId : baseAttackElem.attackId.toString(),
				}
			}
		];

		return new EntityModelDescription(
			entry.baseHp,
			entry.baseInventorySize,
			equipSlots,
			baseAttacks,
			entry.id.toString(),
		);
	}

	public final baseHp : Int;
	public final baseInventorySize : Int;
	public final equipSlots : Array<EntityEquipSlotDescription>;
	public final baseAttacks : Array<EntityBaseAttackItem>;

	public function new(
		baseHp : Int,
		baseInventorySize : Int,
		equipSlots : Array<EntityEquipSlotDescription>,
		baseAttacks : Array<EntityBaseAttackItem>,
		id : String
	) {
		super( id );
		this.baseHp = baseHp;
		this.equipSlots = equipSlots;
		this.baseAttacks = baseAttacks;
		this.baseInventorySize = baseInventorySize;
	}

	public function buildComponent() : EntityComponent {
		return new EntityModelComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntityModelComponentReplicator( parent );
	}
}
