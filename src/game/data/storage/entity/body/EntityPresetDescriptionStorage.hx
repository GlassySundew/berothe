package game.data.storage.entity.body;

class EntityPresetDescriptionStorage extends DescriptionStorageBase<EntityPropertiesDescription, Data.EntityPreset> {

	override function parseItem( entry : Data.EntityPreset ) {
		addItem( new EntityPropertiesDescription( entry ) );
	}
}
