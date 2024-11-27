package game.domain.overworld;

import game.domain.overworld.location.LocationPerRealmContainer;
import game.domain.overworld.location.LocationPerPlayerContainer;
import game.domain.overworld.location.ILocationContainer;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.ItemFactory;
import game.domain.IUpdatable;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.LocationFactory;
import game.data.storage.location.LocationDescription;

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
	final locationFactory : LocationFactory;
	final locationContainers : Map<String, ILocationContainer> = [];

	public function new() {
		inst = this;
		itemFactory = new ItemFactory();
		entityFactory = new EntityFactory();
		locationFactory = new LocationFactory( entityFactory );
	}

	public function getOrCreateLocationByDesc(
		locationDesc : LocationDescription,
		requester : OverworldEntity,
		auth = false
	) : Location {
		if ( locationContainers[locationDesc.id] == null ) {
			var locationContainer = LocationContainerFactory.create(
				locationDesc,
				locationFactory,
				auth
			);
			locationContainers[locationDesc.id] = locationContainer;
			var location = locationContainer.request( requester, auth );
		}
		return locationContainers[locationDesc.id].request( requester, auth );
	}

	public function update( dt : Float, tmod : Float ) {
		for ( location in locationContainers ) {
			location.update( dt, tmod );
		}
	}
}
