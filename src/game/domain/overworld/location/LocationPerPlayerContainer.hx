package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.location.LocationDescription;

class LocationPerPlayerContainer implements ILocationContainer {

	final locationDesc : LocationDescription;
	final locationFactory : LocationFactory;

	final perPlayerLocations : Map<String, OverworldLocationMain> = [];

	public function new(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory
	) {
		this.locationDesc = locationDesc;
		this.locationFactory = locationFactory;
		// location
	}

	#if !debug inline #end
	public function request( requesterUnitID : String, ?auth : Bool = false ) : OverworldLocationMain {

		if ( perPlayerLocations[requesterUnitID] == null ) {

			var location = perPlayerLocations[requesterUnitID] = locationFactory.createLocation( locationDesc );
			// auth ? location.loadAuthoritative() : location.loadNonAuthoritative();
			// location.disposed.then( ( _ ) -> perPlayerLocations.remove( requesterUnitID ) );
		}

		return perPlayerLocations[requesterUnitID];
	}

	public function update() {
		for ( location in perPlayerLocations ) {
			location.update();
		}
	}
}
