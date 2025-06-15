package game.domain.overworld.ecs.systems.units;

import echoes.System;
import hx.concurrent.collection.Collection;
import game.domain.SystemPriority;
import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.ecs.components.units.UnitDynamics;

@:priority( SystemPriority.DISPOSAL )
class UnitCreationConfigEmpty extends System {

	final entitySpawnConfigs : Collection<EntityCreationConfig>;

	public function new( world, ?priority ) {
		super( world, priority );

		entitySpawnConfigs = world.getService( IOverworldContext ).entitySpawnConfigs;
	}

	@:upd
	inline function update() {

		if ( entitySpawnConfigs.length == 0 ) return;

		entitySpawnConfigs.clear();
		
	}
}
