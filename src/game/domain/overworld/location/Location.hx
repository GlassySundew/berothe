package game.domain.overworld.location;

import game.net.server.GameServer;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import hxd.Timer;
import dn.Delayer;
import future.Future;
import tink.CoreApi.CallbackLink;
import game.client.en.comp.view.EntityViewComponent;
import rx.Subscription;
import rx.disposables.ISubscription;
import game.data.storage.DataStorage;
import game.domain.overworld.location.physics.Types.EntityCollisionsService;
import rx.Observable;
import rx.ObservableFactory;
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

	static final fixedTimeStep = 1.0 / 60.0; // Шаг физики в секундах (60 Гц)

	public var locationDataProvider( default, null ) : ILocationObjectsDataProvider;
	public var physics( default, null ) : IPhysicsEngine;

	/** not replicated but created via `location id` -> `geting through DataStorage on client` **/
	public final objectFactory : OverworldStaticObjectsFactory;
	public final entityFactory : EntityFactory;

	public final locationDesc : LocationDescription;
	public final id : String;
	public final chunks : Chunks;
	public final triggers : Array<EntityTrigger> = [];
	public final behaviourManager : EntityBehaviourManager = new EntityBehaviourManager();
	public final localPoints : EntityLocalPoints = new EntityLocalPoints();
	public final delayer : Delayer = new Delayer( Timer.wantedFPS );

	public final onChunkCreated = new Signal<Chunk>();
	public final onEntityAdded = new Signal<OverworldEntity>();
	public final onNoMoreAnchorEntitiesLeft = new Signal();
	public final onEntityRemoved : Signal<OverworldEntity> = new Signal<OverworldEntity>();
	public final entityStream : Observable<OverworldEntity>;
	public final disposed : Future<Bool> = new Future();

	final entities : Array<OverworldEntity> = [];
	final globalEntities : Array<OverworldEntity> = [];
	final entitySubscriptions : Map<OverworldEntity, ISubscription> = [];

	var disposeInvalidate = false;
	var anchorEntitiesPresent : Int = 1;
	var accumulatedTime = 0.0;

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

		entityStream = ObservableFactory.ofIterable( entities )
			.append( ObservableFactory.fromSignal( onEntityAdded ) );
	}

	public function dispose() {
		for ( entity in entities.copy() ) {
			entity.dispose();
		}
		entities.resize( 0 );
		for ( staticObj in globalEntities.copy() ) {
			staticObj.dispose();
		}
		globalEntities.resize( 0 );
		for ( trigger in triggers.copy() ) {
			trigger.dispose();
		}
		triggers.resize( 0 );
		physics.dispose();
		physics = null;
		entities.resize( 0 );
		disposed.resolve( true );
	}

	public function invalidateDispose() {
		disposeInvalidate = true;
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities, 'trying to add an already existing entity: $entity onto a location' );
		Assert.isFalse( entity.disposed.result, "disposed " + entity + " was tried to be added to: " + this );
		#end

		entity.location.getValue()?.removeEntity( entity );

		entities.push( entity );
		entity.setLocation( this );
		chunks.addEntity( entity );
		onEntityAdded.dispatch( entity );

		#if debug
		Assert.notExistsInMap( entity, entitySubscriptions );
		#end

		var sub : CallbackLink = null;
		entitySubscriptions[entity] = Subscription.create(() -> sub.cancel() );
		sub = entity.disposed.then( _ -> {
			removeEntity( entity );
		} );

		if ( entity.desc.getBodyDescription().isAnchor ) anchorEntitiesPresent++;
	}

	public function removeEntity( entity : OverworldEntity ) {
		Assert.isTrue( entity.location.getValue() == this, "entity " + entity + " does not belong to " + this );

		chunks.removeEntity( entity );
		entities.remove( entity );

		entitySubscriptions[entity].unsubscribe();
		entitySubscriptions.remove( entity );

		entity.setLocation( null );
		onEntityRemoved.dispatch( entity );

		if ( entity.desc.getBodyDescription().isAnchor && --anchorEntitiesPresent == 0 ) {
			onNoMoreAnchorEntitiesLeft.dispatch();
		}
	}

	function moveEntityToAnotherLocation(
		entity : OverworldEntity,
		targetLocationDesc : LocationDescription
	) {
		removeEntity( entity );

		var targetLocation = GameCore.inst.getOrCreateLocationByDesc(
			targetLocationDesc,
			entity,
			true
		);
		var exitPoint = Random.fromArray(
			targetLocation.locationDataProvider.getLocationTransitionExits().filter(
				( obj ) -> obj.locationDescId == locationDesc.id
			)
		);

		if ( exitPoint == null ) {
			trace(
				"WARNING: exit point from: "
				+ locationDesc.id
				+ " to: " + targetLocationDesc.id + " was not found"
			);
			return;
		}

		#if server
		entity.transform.onTakeControl.dispatch();

		entity.transform.setVelocity( 0, 0, 0 );
		entity.transform.setPosition( exitPoint.x, exitPoint.y, exitPoint.z );
		entity.transform.onReleaseControl.dispatch();

		targetLocation.addEntity( entity );
		#end
	}

	public function hasEntity( entity : OverworldEntity ) : Bool {
		return entities.contains( entity );
	}

	public function getSpawnByEntityDesc( entityDesc : EntityDescription ) : LocationSpawnVO {
		return locationDataProvider.getSpawnsByEntityDesc( entityDesc )[0];
	}

	public function update( dt : Float, tmod : Float ) {
		accumulatedTime += dt;
		while ( accumulatedTime >= fixedTimeStep ) {
			physics.update( fixedTimeStep );
			accumulatedTime -= fixedTimeStep;
		}

		delayer.update( tmod );

		for ( entity in entities ) {
			if ( entity.disposed.isTriggered ) continue;
			entity.update( dt, tmod );
		}
		for ( entity in globalEntities ) {
			entity.update( dt, tmod );
		}
		behaviourManager.update( dt, tmod );

		if ( disposeInvalidate ) dispose();
	}

	public function loadAuthoritative() {
		// TODO async
		loadData();

		trace( "loading level" );

		onNoMoreAnchorEntitiesLeft.add( invalidateDispose );

		createAndAttachTriggers();
		setupLocationTransitionTriggers();
		createAndAttachStaticObjects();
		createAndAttachPresentEntities();
		attachSpawnPoints();
	}

	public function loadNonAuthoritative() {
		// TODO async
		loadData();

		#if debug createAndAttachTriggers(); #end
		createAndAttachStaticObjects( false );
	}

	public function getTriggerByIdent( ident : String ) : Null<EntityTrigger> {
		for ( trigger in triggers ) {
			if ( trigger.vo.triggerId == ident ) return trigger;
		}
		return null;
	}

	function loadData() {
		locationDataProvider = locationDesc.getLocationDataResolver().objectsDataProvider;
		locationDataProvider.load();
	}

	function createAndAttachTriggers() {
		for ( triggerVO in locationDataProvider.getTriggers() ) {
			triggers.push( new EntityTrigger( triggerVO, this ) );
		}
	}

	function setupLocationTransitionTriggers() {
		for ( trigger in triggers ) {
			if ( trigger.vo.props.locationTransitionId != null ) {
				trigger.cb.postSolveCB.add(
					EntityCollisionsService.unwrapContact.bind( _,
						( entity1, entity2 ) -> {
							var entity = entity1 ?? entity2;
							if (
								entity == null
								|| !entity.desc.getBodyDescription().canChangeLocation
							) return;

							var locationDesc = DataStorage.inst.locationStorage.getById(
								trigger.vo.props.locationTransitionId
							);
							moveEntityToAnotherLocation( entity, locationDesc );
						}
					)
				);
			}
		}
	}

	function createAndAttachStaticObjects( isAuth = true ) {
		var objectsVOs = locationDataProvider.getGlobalObjects();
		for ( objectVO in objectsVOs ) {
			if ( objectVO == null ) continue;
			var entity = objectFactory.createByDesc( objectVO, isAuth );
			addGlobalEntity( entity );
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
			entity.transform.setRotation(
				entityVO.rotationX,
				entityVO.rotationY,
				entityVO.rotationZ
			);
			addEntity( entity );
			if ( entityVO.isBatched ) {
				entity.components.onAppear(
					EntityViewComponent,
					( _, viewComp ) -> {
						viewComp.isBatched.val = true;
					}
				);
			}
		}
	}

	function attachSpawnPoints() {
		var spawnVOs = locationDataProvider.getSpawnPoints();
		for ( spawnVO in spawnVOs ) {
			var emitterMaybe = spawnVO.createSpawnEmitter();
			if ( emitterMaybe == null ) continue;
			emitterMaybe.attachToLocation( this );
		}
	}

	function addGlobalEntity( entity : OverworldEntity ) {
		entity.setLocation( this );
		globalEntities.push( entity );
	}

	@:keep
	function toString() : String {
		return "Location: " + locationDesc.id;
	}
}
