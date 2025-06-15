package game.domain.overworld.location;

import signals.Signal;
import echoes.SystemList;
import echoes.World;
import ecs.systems.ComponentRecycle;
import future.Future;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.ecs.components.units.UnitDynamics.MovedThisTick;
import game.domain.overworld.ecs.components.units.UnitTags.UnitSpawnRequest;
import game.domain.overworld.ecs.systems.location.LocationPlaceStaticObjects;
import game.domain.overworld.ecs.systems.units.UnitCreationConfigEmpty;
import game.domain.overworld.ecs.systems.units.UnitSpawn;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.physics.PhysicsEngineAbstractFactory;

class OverworldLocationMain {

	public final id : String;
	public final locationDesc : LocationDescription;
	public final disposed : Future<Bool> = new Future();
	public final world : World;
	public final initialized : Future<Bool> = new Future<Bool>();

	public var mainSystems( default, null ) : SystemList;
	public var context( default, null ) : IOverworldContext;

	var physics : IPhysicsEngine;

	public function new(
		locationDesc : LocationDescription,
		id : String
	) {

		this.locationDesc = locationDesc;
		this.world = new World();
		this.id = id;
		this.physics = PhysicsEngineAbstractFactory.create();

		locationDesc.getDataResolver().objectsDataProvider.load( init );
		initContext();
	}

	public function update() {

		world.update();
	}

	public function dispose() {

		physics.dispose();
		physics = null;
		disposed.resolve( true );
	}

	function init() {

		initSystems();
		initialized.resolve( true );
	}

	function initContext() {

		context = new OverworldContext( this );

		world.setService( IOverworldContext, context );
	}

	function initSystems() {

		mainSystems = new SystemList( world );

		mainSystems
			.add( new UnitSpawn( world ) )
			.add( new LocationPlaceStaticObjects( world ) )

			.add( new UnitCreationConfigEmpty( world ) )
			.add( new ComponentRecycle(
				world.getComponentStorage( UnitSpawnRequest ),
				world.getView( [UnitSpawnRequest] ),
				world
			) )
			.add( new ComponentRecycle(
				world.getComponentStorage( MovedThisTick ),
				world.getView( [MovedThisTick] ),
				world
			) )

			.activate();
	}
}
