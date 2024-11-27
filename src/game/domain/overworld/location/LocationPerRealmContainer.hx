package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.location.LocationDescription;

class LocationPerRealmContainer implements ILocationContainer {

	final factory : LocationFactory;
	final locationDesc : LocationDescription;

	var location : Location;

	public function new(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory,
		auth : Bool
	) {
		this.factory = locationFactory;
		this.locationDesc = locationDesc;
	}

	#if !debug inline #end
	public function request( requestor : OverworldEntity, ?auth : Bool = false ) : Location {
		if ( location == null ) {
			location = factory.createLocation( locationDesc );
			auth ? location.loadAuthoritative() : location.loadNonAuthoritative();

			location.disposed.then( _ -> {
				location = null;
			} );
		}
		return location;
	}

	public function update( dt : Float, tmod : Float ) {
		if ( location != null ) location.update( dt, tmod );
	}
}
