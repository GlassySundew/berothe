package game.data.storage.entity.body.view;

import game.data.storage.entity.component.EntityComponentDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityLightSourceDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_lightSource
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
}
