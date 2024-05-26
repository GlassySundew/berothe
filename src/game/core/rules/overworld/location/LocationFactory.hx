package game.core.rules.overworld.location;

import game.data.storage.location.LocationDescription;

class LocationFactory {

	public function new() {}

	public function createLocation( locationDesc : LocationDescription ) : Location {
		return new Location( locationDesc );
	}
}
