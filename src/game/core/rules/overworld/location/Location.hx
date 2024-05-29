package game.core.rules.overworld.location;

import signals.Signal;
import game.data.location.objects.LocationSpawnDescription;
import game.data.storage.entity.EntityDescription;
import util.Assert;
import game.core.rules.overworld.entity.EntityFactory;
import game.core.rules.overworld.entity.OverworldEntity;
import game.data.location.prefab.LocationDataResolver;
import game.data.storage.location.LocationDescription;

class Location {

	public final locationDesc : LocationDescription;
	public final entityFactory : EntityFactory;
	public final onChunkCreated : Signal<Chunk> = new Signal<Chunk>();
	public final id : Int;

	var locationDataProvider : ILocationObjectsDataProvider;
	var locationDataResolver : LocationDataResolver;
	var entities : Array<OverworldEntity> = [];
	var chunks : Chunks;

	public function new( locationDesc : LocationDescription, id : Int ) {
		this.locationDesc = locationDesc;
		this.id = id;

		entityFactory = new EntityFactory( this );
		chunks = new Chunks( this, locationDesc.chunkSize );

		// TODO async
		load();
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities, "trying to add an already existing entity onto a location" );
		#end

		entities.push( entity );
		chunks.placeEntity( entity );
	}

	public function load() {
		locationDataResolver = locationDesc.createLocationDataResolver();
		locationDataProvider = locationDataResolver.objectsDataProvider;
		locationDataProvider.load();
	}

	public function getSpawnByEntityDesc( entityDesc : EntityDescription ) : LocationSpawnDescription {
		return locationDataProvider.getSpawnsByEntityDesc( entityDesc )[0];
	}
}
