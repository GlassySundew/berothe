package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.location.LocationDescription;

class LocationPerRealmContainer implements ILocationContainer {

	final factory : LocationFactory;
	final locationDesc : LocationDescription;

	var location : OverworldLocationMain;

	public function new(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory,
		auth : Bool
	) {
		this.factory = locationFactory;
		this.locationDesc = locationDesc;
	}

	#if !debug inline #end
	public function request( requesterUnitID : String, ?auth : Bool = false ) : OverworldLocationMain {
		if ( location == null ) {
			location = factory.createLocation( locationDesc );
			// auth ? location.loadAuthoritative() : location.loadNonAuthoritative();

			// location.disposed.then( _ -> {
			// 	location = null;
			// } );
		}
		return location;
	}

	public function update() {
		if ( location != null ) location.update();
	}
}
