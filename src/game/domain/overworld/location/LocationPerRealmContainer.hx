package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.location.LocationDescription;

class LocationPerRealmContainer implements ILocationContainer {

	public final location : Location;

	public function new(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory,
		auth : Bool
	) {
		location = locationFactory.createLocation( locationDesc );
		auth ? location.loadAuthoritative() : location.loadNonAuthoritative();
	}

	#if !debug inline #end
	public function request( requestor : OverworldEntity, ?auth : Bool = false ) : Location {
		return location;
	}

	public function update( dt : Float, tmod : Float ) {
		location.update( dt, tmod );
	}
}
