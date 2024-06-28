package game.core.rules.overworld.location;

import game.core.rules.overworld.location.objects.OverworldObjectsFactory;
import game.data.location.LocationObjectFactory;
import game.core.rules.overworld.location.objects.OverworldStaticObject;
import game.data.location.objects.LocationObject;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import game.physics.PhysicsEngineAbstractFactory;
import signals.Signal;
import game.data.location.objects.LocationSpawn;
import game.data.storage.entity.EntityDescription;
import util.Assert;
import game.core.rules.overworld.entity.OverworldEntity;
import game.data.location.prefab.LocationDataResolver;
import game.data.storage.location.LocationDescription;

class Location {

	public final locationDesc : LocationDescription;
	public final id : String;
	public final physics : IPhysicsEngine;

	public final chunks : Chunks;
	public final globalObjects : Array<OverworldStaticObject> = [];

	public final objectFactory : OverworldObjectsFactory;
	public final onChunkCreated = new Signal<Chunk>();
	public final onEntityAdded = new Signal<OverworldEntity>();

	var locationDataProvider : ILocationObjectsDataProvider;
	var entities : Array<OverworldEntity> = [];

	public function new( locationDesc : LocationDescription, id : String ) {
		this.locationDesc = locationDesc;
		this.id = id;
		objectFactory = new OverworldObjectsFactory( this );

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

	public function getSpawnByEntityDesc( entityDesc : EntityDescription ) : LocationSpawn {
		return locationDataProvider.getSpawnsByEntityDesc( entityDesc )[0];
	}

	public function update( dt : Float ) {
		physics.update( dt );
	}

	function load() {
		// TODO async
		locationDataProvider = locationDesc.createLocationDataResolver().objectsDataProvider;
		locationDataProvider.load();

		addStaticObjects();
	}

	function addStaticObjects() {
		var objects = locationDataProvider.getGlobalObjects();
		for ( object in objects ) {
			globalObjects.push( objectFactory.byDesc( object ) );
		}
	}
}
