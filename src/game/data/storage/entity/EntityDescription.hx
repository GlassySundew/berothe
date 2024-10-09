package game.data.storage.entity;

import game.data.storage.entity.body.EntityPresetDescription;

class EntityDescription extends DescriptionBase {

	var presetId : String;

	public function new( entry : Data.Entity ) {
		super( entry.id.toString() );
		presetId = entry.presetId.toString();
	}

	public function getBodyDescription() : EntityPresetDescription {
		return DataStorage.inst.entityPresetStorage.getDescriptionById( presetId );
	}

	@:keep
	public function toString() :String {
		return "EntityDescription: " + id;
	}
}
