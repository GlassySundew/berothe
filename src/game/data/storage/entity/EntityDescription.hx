package game.data.storage.entity;

import game.data.storage.entity.body.EntityBodyDescription;

class EntityDescription extends DescriptionBase {

	var bodyId : String;

	public function new( entry : Data.Entity ) {
		super( entry.id.toString() );
		bodyId = entry.bodyId.toString();
	}

	public function getBodyDescription() : EntityBodyDescription {
		return DataStorage.inst.entityBodyStorage.getDescriptionById( bodyId );
	}
}
