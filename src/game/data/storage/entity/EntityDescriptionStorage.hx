package game.data.storage.entity;

class EntityDescriptionStorage extends DescriptionStorageBase<EntityDescription, Data.Entity> {

	static final PLAYER_ENTITY_ID = Data.EntityKind.player.toString();

	public function getPlayerDescription() : EntityDescription {
		return getDescriptionById( PLAYER_ENTITY_ID );
	}

	function parseItem( entry : Data.Entity ) {
		addItem( new EntityDescription( entry ) );
	}
}
