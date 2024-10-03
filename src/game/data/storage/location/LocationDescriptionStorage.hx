package game.data.storage.location;

import game.data.storage.location.LocationDescription;

class LocationDescriptionStorage extends DescriptionStorageBase<LocationDescription, Data.Location> {

	public function getStartLocationDescription() : LocationDescription {
		return getDescriptionById( DataStorage.inst.rule.playerStartLocation );
	}

	override function parseItem( entry : Data.Location ) {
		addItem( new LocationDescription( entry ) );
	}
}
