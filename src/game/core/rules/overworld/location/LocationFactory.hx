package game.core.rules.overworld.location;

import game.data.storage.location.LocationDescription;

class LocationFactory {

	static var LOCATION_ID_STUB = 0;

	var gameCore : GameCore;

	public function new( gameCore : GameCore ) {
		this.gameCore = gameCore;
	}

	public function createLocation( locationDesc : LocationDescription ) : Location {
		var location = new Location( locationDesc, ++LOCATION_ID_STUB );
		gameCore.onLocationCreated.dispatch( location );
		return location;
	}
}
