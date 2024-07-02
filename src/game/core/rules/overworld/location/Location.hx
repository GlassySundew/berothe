package game.core.rules.overworld.location;

import signals.Signal;
import util.Assert;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.location.OverworldObjectsFactory;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import game.data.location.objects.LocationSpawn;
import game.data.storage.entity.EntityDescription;
import game.data.storage.location.LocationDescription;
import game.physics.PhysicsEngineAbstractFactory;

class Location {

	public final locationDesc : LocationDescription;
	public final id : String;
	public final physics : IPhysicsEngine;

	public final chunks : Chunks;

	/** not replicated fully but via location id -> geting through DataStorage on client **/
	public final globalObjects : Array<OverworldEntity> = [];

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
		chunks.placeEntity( entity );
		entity.addToLocation( this );
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

		createAndAttachStaticObjects();
	}

	function createAndAttachStaticObjects() {
		var objects = locationDataProvider.getGlobalObjects();
		for ( object in objects ) {
			globalObjects.push( objectFactory.createByDesc( object ) );
		}

		for ( globalObject in globalObjects ) {
			addGlobalEntity( globalObject );
		}
	}

	function addGlobalEntity( entity : OverworldEntity ) {
		entity.addToLocation( this );
	}
}
