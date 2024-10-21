package game.data.storage.entity;

import game.data.storage.entity.body.EntityPresetDescription;

class EntityDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.Entity ) : EntityDescription {
		return new EntityDescription(
			// entry.control.
			entry.presetId.toString(),
			entry.id.toString()
		);
	}

	final presetId : String;

	public function new( presetId : String, id : String ) {
		super( id );
		this.presetId = presetId;
	}

	public function getBodyDescription() : EntityPresetDescription {
		return DataStorage.inst.entityPresetStorage.getById( presetId );
	}

	@:keep
	public function toString() : String {
		return "EntityDescription: " + id;
	}
}
