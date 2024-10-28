package game.domain.overworld;

import game.domain.overworld.item.Item;
import game.domain.overworld.item.ItemFactory;
import game.domain.IUpdatable;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

class GameCore implements IUpdatable {

	public static var inst( default, null ) : GameCore;

	public var onLocationCreated( get, never ) : Signal<Location>;
	inline function get_onLocationCreated() : Signal<Location> {
		return locationFactory.onLocationCreated;
	}

	public var onEntityCreated( get, never ) : Signal<OverworldEntity>;
	inline function get_onEntityCreated() : Signal<OverworldEntity> {
		return entityFactory.onEntityCreated;
	}

	public var onItemCreated( get, never ) : Signal<Item>;
	inline function get_onItemCreated() : Signal<Item> {
		return itemFactory.onItemCreated;
	}

	public final entityFactory : EntityFactory;
	public final itemFactory : ItemFactory;
	public final onFrame : Signal<Float, Float> = new Signal<Float, Float>();
	final locationFactory : LocationFactory;
	final locations : Map<String, Location> = [];

	public function new() {
		inst = this;
		itemFactory = new ItemFactory();
		entityFactory = new EntityFactory();
		locationFactory = new LocationFactory( entityFactory );
	}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription,
		auth = false
	) : Location {
		if ( locations[locationDesc.id] == null ) {
			var location = locations[locationDesc.id] = locationFactory.createLocation( locationDesc );
			auth ? location.loadAuthoritative() : location.loadNonAuthoritative();
		}
		return locations[locationDesc.id];
	}

	public function update( dt : Float, tmod : Float ) {
		for ( location in locations ) {
			location.update( dt, tmod );
		}
		onFrame.dispatch( dt, tmod );
	}
}
