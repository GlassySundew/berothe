package game.data.storage.entity.body;

class EntityPresetDescriptionStorage extends DescriptionStorageBase<EntityPresetDescription, Data.EntityPreset> {

	override function parseItem( entry : Data.EntityPreset ) {
		addItem( new EntityPresetDescription( entry ) );
	}
}
