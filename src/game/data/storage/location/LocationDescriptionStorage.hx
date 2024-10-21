package game.data.storage.location;

import game.data.storage.location.LocationDescription;

class LocationDescriptionStorage extends DescriptionStorageBase<LocationDescription, Data.Location> {

	public function getStartLocationDescription() : LocationDescription {
		return getById( DataStorage.inst.rule.playerStartLocation );
	}

	override function parseItem( entry : Data.Location ) {
		addItem( new LocationDescription( entry ) );
	}
}
