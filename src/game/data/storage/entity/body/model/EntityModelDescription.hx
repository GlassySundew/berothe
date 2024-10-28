package game.data.storage.entity.body.model;

import game.net.entity.component.EntitySimpleComponentReplicator;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntityModelComponentReplicator;

class EntityModelDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_model
	) : EntityModelDescription {
		if ( entry == null ) return null;

		var equipSlots = entry.equipment != null ? [
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
		] : [];

		return new EntityModelDescription(
			entry.baseHp,
			entry.baseInventorySize,
			entry.baseSpeed,
			equipSlots,
			entry.factionId.toString(),
			entry.displayName,
			entry.hideNameByDefault,
			entry.id.toString(),
		);
	}

	public final baseHp : Int;
	public final baseInventorySize : Int;
	public final baseSpeed : Float;
	public final equipSlots : Array<EntityEquipSlotDescription>;
	public final factionId : String;
	public final displayName : String;
	public final hideNameByDefault : Bool;

	public function new(
		baseHp : Int,
		baseInventorySize : Int,
		baseSpeed : Float,
		equipSlots : Array<EntityEquipSlotDescription>,
		factionId : String,
		displayName : String,
		hideNameByDefault : Bool,
		id : String
	) {
		super( id ?? "model" );
		this.baseHp = baseHp;
		this.equipSlots = equipSlots;
		this.baseSpeed = baseSpeed;
		this.baseInventorySize = baseInventorySize;
		this.factionId = factionId;
		this.displayName = displayName;
		this.hideNameByDefault = hideNameByDefault;
	}

	public function buildComponent() : EntityComponent {
		return new EntityModelComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntityModelComponentReplicator( parent );
	}
}
