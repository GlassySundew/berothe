package game.core.rules.overworld.location;

import game.physics.PhysicsEngineAbstractFactory;
import signals.Signal;
import game.data.location.objects.LocationSpawnDescription;
import game.data.storage.entity.EntityDescription;
import util.Assert;
import game.core.rules.overworld.entity.OverworldEntity;
import game.data.location.prefab.LocationDataResolver;
import game.data.storage.location.LocationDescription;

class Location {

	public final locationDesc : LocationDescription;
	public final id : String;
	public final onChunkCreated = new Signal<Chunk>();
	public final onEntityAdded = new Signal<OverworldEntity>();
	public final chunks : Chunks;

	final physics : IPhysicsEngine;

	var locationDataProvider : ILocationObjectsDataProvider;
	var locationDataResolver : LocationDataResolver;
	var entities : Array<OverworldEntity> = [];

	public function new( locationDesc : LocationDescription, id : String ) {
		this.locationDesc = locationDesc;
		this.id = id;

		chunks = new Chunks( this, locationDesc.chunkSize );
		physics = PhysicsEngineAbstractFactory.create();

		load();
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities, "trying to add an already existing entity onto a location" );
		#end

		entities.push( entity );
		entity.addToLocation( this );
		chunks.placeEntity( entity );
		onEntityAdded.dispatch( entity );
	}

	public function getSpawnByEntityDesc( entityDesc : EntityDescription ) : LocationSpawnDescription {
		return locationDataProvider.getSpawnsByEntityDesc( entityDesc )[0];
	}

	public function update( dt : Float ) {
		physics.update( dt );
	}

	function load() {
		// TODO async
		locationDataResolver = locationDesc.createLocationDataResolver();
		locationDataProvider = locationDataResolver.objectsDataProvider;
		locationDataProvider.load();
	}
}
