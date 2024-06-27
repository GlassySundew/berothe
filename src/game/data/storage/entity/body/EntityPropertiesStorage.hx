package game.data.storage.entity.body;

import game.data.storage.entity.component.EntityComponentDescription;

class EntityPropertiesStorage extends DescriptionStorageBase<EntityComponentDescription, Data.EntityBody_properties> {

	public function provideExistingDescription( desc : EntityComponentDescription ) {
		addItem( desc );
	}
}
