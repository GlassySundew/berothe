package game.domain.overworld.location;

import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.data.storage.location.LocationDescription;

class LocationFactory {

	static var LOCATION_ID_STUB = 0;

	public final onLocationCreated = new Signal<OverworldLocationMain>();

	public function new() {}

	public function createLocation( locationDesc : LocationDescription ) : OverworldLocationMain {

		var location = new OverworldLocationMain( locationDesc, '${++LOCATION_ID_STUB}' );
		location.initialized.then( _ -> onLocationCreated.dispatch( location ) );
		return location;
	}
}
