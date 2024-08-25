package game.data.storage.item;

class ItemDescription extends DescriptionBase {

	public function new( entry : Data.Item ) {
		super( entry.id.toString() );
	}
}
