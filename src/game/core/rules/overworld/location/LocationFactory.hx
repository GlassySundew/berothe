package game.core.rules.overworld.location;

import signals.Signal;
import game.data.storage.location.LocationDescription;

class LocationFactory {

	static var LOCATION_ID_STUB = 0;

	public final onLocationCreated = new Signal<Location>();

	public function new() {}

	public function createLocation( locationDesc : LocationDescription ) : Location {
		var location = new Location( locationDesc, '${++LOCATION_ID_STUB}' );
		onLocationCreated.dispatch( location );
		return location;
	}
}
