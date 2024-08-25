package game.domain.overworld.location;

import game.domain.overworld.entity.EntityFactory;
import signals.Signal;
import util.Assert;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.OverworldStaticObjectsFactory;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;
import game.data.storage.location.LocationDescription;
import game.physics.PhysicsEngineAbstractFactory;

class Location {

	public final locationDesc : LocationDescription;
	public final id : String;
	public final physics : IPhysicsEngine;
	public final entityFactory : EntityFactory;

	public final chunks : Chunks;

	/** not replicated but created via `location id` -> `geting through DataStorage on client` **/
	public final globalObjects : Array<OverworldEntity> = [];
	public final objectFactory : OverworldStaticObjectsFactory;

	public final onChunkCreated = new Signal<Chunk>();
	public final onEntityAdded = new Signal<OverworldEntity>();

	var locationDataProvider : ILocationObjectsDataProvider;
	var entities : Array<OverworldEntity> = [];

	public function new(
		locationDesc : LocationDescription,
		entityFactory : EntityFactory,
		id : String
	) {
		this.locationDesc = locationDesc;
		this.id = id;
		this.entityFactory = entityFactory;

		objectFactory = new OverworldStaticObjectsFactory( this );

		chunks = new Chunks( this, locationDesc.chunkSize );
		physics = PhysicsEngineAbstractFactory.create();
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities, 'trying to add an already existing entity: $entity onto a location' );
		#end

		if ( entity.location.getValue() != null ) {
			entity.location.getValue().removeEntity( entity );
		}

		entities.push( entity );
		chunks.addEntity( entity );
		entity.addToLocation( this );
		onEntityAdded.dispatch( entity );

		entity.disposed.then( ( _ ) -> removeEntity( entity ) );
	}

	public function removeEntity( entity : OverworldEntity ) {
		chunks.removeEntity( entity );
		entities.remove( entity );
	}

	public function hasEntity( entity : OverworldEntity ) : Bool {
		return entities.contains( entity );
	}

	public function getSpawnByEntityDesc( entityDesc : EntityDescription ) : LocationSpawnVO {
		return locationDataProvider.getSpawnsByEntityDesc( entityDesc )[0];
	}

	public function update( dt : Float, tmod : Float ) {
		physics.update( dt );
		for ( entity in entities ) {
			entity.update( dt, tmod );
		}
	}

	public function loadAuthoritative() {
		// TODO async
		loadData();

		createAndAttachStaticObjects();
		createAndAttachPresentEntities();
	}

	public function loadNonAuthoritative() {
		// TODO async
		loadData();

		createAndAttachStaticObjects();
	}

	function loadData() {
		locationDataProvider = locationDesc.createLocationDataResolver().objectsDataProvider;
		locationDataProvider.load();
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

	function createAndAttachPresentEntities() {
		var entityVOs = locationDataProvider.getPresentEntities();
		for ( entityVO in entityVOs ) {
			var entity = entityFactory.createEntity( entityVO.entityDesc );
			entity.transform.setPosition(
				entityVO.x,
				entityVO.y,
				entityVO.z
			);
			addEntity( entity );
		}
	}

	function addGlobalEntity( entity : OverworldEntity ) {
		entity.addToLocation( this );
	}
}
