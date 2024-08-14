package game.domain;

import game.domain.IUpdatable;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

class GameCore implements IUpdatable {

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
			return
				locations[locationDesc.id] = locationFactory.createLocation( locationDesc );
		}
	}

	public function update( dt : Float, tmod : Float ) {
		for ( location in locations ) {
			location.update( dt, tmod );
		}
	}
}
