package game.core;

import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityFactory;
import signals.Signal;
import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

class GameCore {

	public var onLocationCreated( get, never ) : Signal<Location>;
	inline function get_onLocationCreated() : Signal<Location> {
		return locationFactory.onLocationCreated;
	}

	public var onEntityCreated( get, never ) : Signal<OverworldEntity>;
	inline function get_onEntityCreated() : Signal<OverworldEntity> {
		return entityFactory.onEntityCreated;
	}

	public final entityFactory : EntityFactory;
	final locationFactory : LocationFactory;
	final locations : Map<String, Location> = [];

	public function new() {
		locationFactory = new LocationFactory();
		entityFactory = new EntityFactory();
	}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription
	) : Location {
		if ( locations.exists( locationDesc.id ) ) {
			return locations[locationDesc.id];
		} else {
			return locations[locationDesc.id] = locationFactory.createLocation( locationDesc );
		}
	}

	public function update( dt : Float ) {
		for ( location in locations ) {
			location.update( dt );
		}
	}
}
