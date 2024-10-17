package game.data.storage.entity.body.view;

import game.client.en.comp.view.EntityLightSourceComponent;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityLightSourceDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_lightSource
	) : EntityLightSourceDescription {
		if ( entry == null ) return null;
		return new EntityLightSourceDescription(
			entry.id.toString(),
			EntityEquipmentSlotType.fromCdb( entry.equipSource ),
			entry.prefab
		);
	}

	public final equipSource : EntityEquipmentSlotType;
	public final lightPrefabPath : String;

	public function new(
		id : String,
		equipSource : EntityEquipmentSlotType,
		lightPrefabPath : String
	) {
		super( id );
		this.equipSource = equipSource;
		this.lightPrefabPath = lightPrefabPath;
	}

	public function buildComponent() : EntityComponent {
		return new EntityLightSourceComponent( this );
	}

	public function buildCompReplicator(
		?parent : NetNode
	) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
