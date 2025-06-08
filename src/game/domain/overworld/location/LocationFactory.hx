package game.domain.overworld.location;

import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.data.storage.location.LocationDescription;

class LocationFactory {

	static var LOCATION_ID_STUB = 0;

	public function new() {}

	public function createLocation( locationDesc : LocationDescription ) : Location {
		var location = new Location( locationDesc, '${++LOCATION_ID_STUB}' );
		return location;
	}
}
