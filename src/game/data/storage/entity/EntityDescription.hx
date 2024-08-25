package game.data.storage.entity;

import game.data.storage.entity.body.EntityPropertiesDescription;

class EntityDescription extends DescriptionBase {

	var presetId : String;

	public function new( entry : Data.Entity ) {
		super( entry.id.toString() );
		presetId = entry.presetId.toString();
	}

	public function getBodyDescription() : EntityPropertiesDescription {
		return DataStorage.inst.entityPresetStorage.getDescriptionById( presetId );
	}

	@:keep
	public function toString() :String {
		return "EntityDescription: " + id;
	}
}
