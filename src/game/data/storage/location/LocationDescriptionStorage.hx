package game.data.storage.location;

import game.data.storage.location.LocationDescription;

class LocationDescriptionStorage extends DescriptionStorageBase<LocationDescription, Data.Location> {

	public function getStartLocationDescription() : LocationDescription {
		var locationId =
			#if prod
			DataStorage.inst.rule.playerStartLocation;
			#else
			DataStorage.inst.rule.debugStartLocation;
			#end

		return getById( locationId );
	}

	override function parseItem( entry : Data.Location ) {
		addItem( LocationDescription.fromCdb( entry ) );
	}
}
