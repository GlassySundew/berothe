package game.data.storage.entity.body;

class EntityBodyDescriptionStorage extends DescriptionStorageBase<EntityBodyDescription, Data.EntityBody> {

	override function parseItem( entry : Data.EntityBody ) {
		addItem( new EntityBodyDescription( entry ) );
	}
}
