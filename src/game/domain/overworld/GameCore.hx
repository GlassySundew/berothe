package game.domain.overworld;

import game.domain.overworld.location.LocationPerRealmContainer;
import game.domain.overworld.location.LocationPerPlayerContainer;
import game.domain.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.ILocationContainer;
import game.domain.overworld.ecs.systems.units.UnitSpawnSystem;
import echoes.SystemList;
import echoes.World;

class LocationContainerFactory {

	public static function create(
		locationDesc : LocationDescription,
		locationFactory : LocationFactory,
		auth : Bool
	) : ILocationContainer {
		return switch locationDesc.instancing {
			case PerPlayer:
				new LocationPerPlayerContainer( locationDesc, locationFactory );
			case PerRealm:
				new LocationPerRealmContainer( locationDesc, locationFactory, auth );
			case e: throw e + " is a not supported location instancing type";
		}
	}
}

class GameCore {

	final locationContainers : Map<String, ILocationContainer> = [];
	final locationFactory = new LocationFactory();

	public function new() {}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription,
		requesterUnitID : String,
		auth = false
	) : Location {

		if ( locationContainers[locationDesc.id] == null ) {

			var locationContainer = LocationContainerFactory.create(
				locationDesc,
				locationFactory,
				auth
			);
			locationContainers[locationDesc.id] = locationContainer;
			var location = locationContainer.request( requesterUnitID, auth );
		}

		return locationContainers[locationDesc.id].request( requesterUnitID, auth );
	}

	public function update() {

		for ( location in locationContainers ) {

			location.update();
		}
	}
}
