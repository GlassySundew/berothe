package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.location.LocationDescription;

class LocationPerPlayerContainer implements ILocationContainer {

	final locationDesc : LocationDescription;
	final locationFactory : LocationFactory;

	final perPlayerLocations : Map<String, Location> = [];

	public function new(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory
	) {
		this.locationDesc = locationDesc;
		this.locationFactory = locationFactory;
		// location
	}

	#if !debug inline #end
	public function request( requester : OverworldEntity, ?auth : Bool = false ) : Location {
		if ( perPlayerLocations[requester.id] == null ) {
			var location = perPlayerLocations[requester.id] = locationFactory.createLocation( locationDesc );
			auth ? location.loadAuthoritative() : location.loadNonAuthoritative();
			location.disposed.then( ( _ ) -> perPlayerLocations.remove( requester.id ) );
		}

		return perPlayerLocations[requester.id];
	}

	public function update( dt : Float, tmod : Float ) {
		for ( location in perPlayerLocations ) {
			location.update( dt, tmod );
		}
	}
}
