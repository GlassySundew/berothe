package game.domain.overworld.location;

import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.data.storage.location.LocationDescription;

class LocationFactory {

	static var LOCATION_ID_STUB = 0;

	public final onLocationCreated = new Signal<Location>();

	final entityFactory : EntityFactory;

	public function new( entityFactory : EntityFactory ) {
		this.entityFactory = entityFactory;
	}

	public function createLocation( locationDesc : LocationDescription ) : Location {
		var location = new Location( locationDesc, entityFactory, '${++LOCATION_ID_STUB}' );
		onLocationCreated.dispatch( location );
		return location;
	}
}
