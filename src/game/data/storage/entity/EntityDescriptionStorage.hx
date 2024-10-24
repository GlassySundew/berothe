package game.data.storage.entity;

class EntityDescriptionStorage extends DescriptionStorageBase<EntityDescription, Data.Entity> {

	static final PLAYER_ENTITY_ID = Data.EntityKind.player.toString();

	public function getPlayerDescription() : EntityDescription {
		return getById( PLAYER_ENTITY_ID );
	}

	override function parseItem( entry : Data.Entity ) {
		addItem( EntityDescription.fromCdb( entry ) );
	}
}
