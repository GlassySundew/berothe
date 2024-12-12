package game.data.storage.npcResponses;

class NpcResponseStorage extends DescriptionStorageBase<NpcResponseDescription, Data.NpcResponse> {

	override function parseItem( entry : Data.NpcResponse ) {
		addItem( NpcResponseDescription.fromCdb( entry ) );
	}
}
