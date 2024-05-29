package game.core;

import signals.Signal;
import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

class GameCore {

	public final onLocationCreated : Signal<Location> = new Signal<Location>();

	final locationFactory : LocationFactory;
	final locations : Map<String, Location> = [];

	public function new() {
		locationFactory = new LocationFactory( this );
	}

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
