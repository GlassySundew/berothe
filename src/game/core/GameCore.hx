package game.core;

import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

class GameCore {

	var locationFactory : LocationFactory = new LocationFactory();
	var locations : Map<String, Location> = [];

	public function new() {}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription
	) : Location {
		if ( locations.exists( locationDesc.id ) ) {
			return locations[locationDesc.id];
		} else {
			return locations[locationDesc.id] = locationFactory.createLocation( locationDesc );
		}
	}

	
}
