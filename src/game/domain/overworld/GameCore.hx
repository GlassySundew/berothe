package game.domain.overworld;

import echoes.SystemList;
import echoes.World;
import signals.Signal;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.ecs.systems.units.UnitSpawn;
import game.domain.overworld.location.ILocationContainer;
import game.domain.overworld.location.OverworldLocationMain;
import game.domain.overworld.location.LocationFactory;
import game.domain.overworld.location.LocationPerPlayerContainer;
import game.domain.overworld.location.LocationPerRealmContainer;

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

	public var onLocationCreated( get, never ) : Signal<OverworldLocationMain>;
	inline function get_onLocationCreated() : Signal<OverworldLocationMain> {
		return locationFactory.onLocationCreated;
	}

	final locationContainers : Map<String, ILocationContainer> = [];
	final locationFactory = new LocationFactory();

	public function new() {}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription,
		requesterUnitID : String,
		auth = false
	) : OverworldLocationMain {

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
