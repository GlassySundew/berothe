package game.domain.overworld.location;

import echoes.SystemList;
import echoes.World;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.ecs.systems.units.UnitSpawnSystem;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.physics.PhysicsEngineAbstractFactory;

class Location {

	public final id : String;
	public final physics : IPhysicsEngine;
	public final locationDesc : LocationDescription;

	final world : World;

	public var context( default, null ) : IOverworldContext;

	public function new(
		locationDesc : LocationDescription,
		id : String
	) {

		this.locationDesc = locationDesc;
		this.world = new World();
		this.id = id;
		this.physics = PhysicsEngineAbstractFactory.create();

		init();
	}

	public function update() {

		world.update();
	}

	function init() {

		initializeContext();
		initializeSystems();
	}

	function initializeContext() {

		context = new OverworldContext();

		world.setService( IOverworldContext, context );
	}

	function initializeSystems() {

		final systems = new SystemList( world );

		systems.add( new UnitSpawnSystem( world ) );

		systems.activate();
	}
}
