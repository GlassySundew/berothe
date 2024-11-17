package game.data.storage.entity.body.model;

import game.net.entity.component.EntitySimpleComponentReplicator;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntityModelComponentReplicator;

enum RandomDistributionType {
	LINEAR;
	SKEW( power : Float );
}

typedef SpawnInventory = {
	var itemDescId : String;
	var distribution : RandomDistributionType;
	var botEdgeRnd : Int;
	var topEdgeRnd : Int;
}

class EntityModelDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_model
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

		var spawnInventory = entry.spawnInventory == null ? [] : [
			for ( element in entry.spawnInventory ) {
				itemDescId : element.item.id.toString(),
				distribution : switch element.distribution {
					case Linear: LINEAR;
					case Skew( power ): SKEW( power );
				},
				botEdgeRnd : element.botEdgeRnd,
				topEdgeRnd : element.topEdgeRnd
			}
		];

		var speechDamaged = entry.speechDamaged == null ? [] : [
			for ( speech in entry.speechDamaged ) speech.speech
		];

		return new EntityModelDescription(
			entry.baseHp,
			entry.baseInventorySize,
			entry.baseSpeed,
			entry.baseDefence,
			equipSlots,
			entry.factionId.toString(),
			entry.displayName,
			entry.hideNameByDefault,
			speechDamaged,
			spawnInventory,
			entry.id.toString(),
		);
	}

	public final baseHp : Int;
	public final baseInventorySize : Int;
	public final baseSpeed : Float;
	public final baseDefence : Int;
	public final equipSlots : Array<EntityEquipSlotDescription>;
	public final factionId : String;
	public final displayName : String;
	public final hideNameByDefault : Bool;
	public final spawnInventory : Array<SpawnInventory>;
	public final speechDamaged : Array<String>;

	public function new(
		baseHp : Int,
		baseInventorySize : Int,
		baseSpeed : Float,
		baseDefence : Int,
		equipSlots : Array<EntityEquipSlotDescription>,
		factionId : String,
		displayName : String,
		hideNameByDefault : Bool,
		speechDamaged : Array<String>,
		spawnInventory : Array<SpawnInventory>,
		id : String
	) {
		super( id ?? "model" );
		this.baseHp = baseHp;
		this.equipSlots = equipSlots;
		this.baseSpeed = baseSpeed;
		this.baseDefence = baseDefence;
		this.baseInventorySize = baseInventorySize;
		this.factionId = factionId;
		this.displayName = displayName;
		this.hideNameByDefault = hideNameByDefault;
		this.spawnInventory = spawnInventory;
		this.speechDamaged = speechDamaged;
	}

	public function buildComponent() : EntityComponent {
		return new EntityModelComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntityModelComponentReplicator( parent );
	}
}
