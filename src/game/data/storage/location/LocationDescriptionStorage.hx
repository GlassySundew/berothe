package game.data.storage.location;

import game.data.storage.location.LocationDescription;

class LocationDescriptionStorage extends DescriptionStorageBase<LocationDescription, Data.Location> {

	public static final PLAYER_START_LOCATION_ID = Data.LocationKind.start.toString();

	public function getStartLocationDescription() : LocationDescription {
		return getDescriptionById( PLAYER_START_LOCATION_ID );
	}

	function parseItem( entry : Data.Location ) {
		addItem( new LocationDescription( entry ) );
	}
}
