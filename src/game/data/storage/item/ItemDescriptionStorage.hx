package game.data.storage.item;

class ItemDescriptionStorage extends DescriptionStorageBase<ItemDescription, Data.Item> {

	override function parseItem( entry : Data.Item ) {
		addItem( ItemDescription.fromCdb( entry ) );
	}
}
