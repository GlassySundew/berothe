package game.data.storage.faction;

import game.data.storage.faction.FactionDescription;

class FactionDescriptionStorage extends DescriptionStorageBase<FactionDescription, Data.Faction> {

	override function parseItem( entry : Data.Faction ) {
		addItem( FactionDescription.fromCdb( entry ) );
	}
}
