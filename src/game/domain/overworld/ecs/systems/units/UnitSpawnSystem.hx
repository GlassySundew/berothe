package game.domain.overworld.ecs.systems.units;

import echoes.Entity;
import game.domain.overworld.ecs.components.units.BaseStatsComps.MaxHpBaseStat;
import game.domain.overworld.ecs.components.units.BaseStatsComps.BaseDefenseStat;
import game.domain.overworld.config.EntityCreationConfig;
import hx.concurrent.collection.Queue;
import echoes.System;

class UnitSpawnSystem extends System {

	final queue : Queue<EntityCreationConfig>;

	public function new( world, ?priority ) {
		super( world, priority );

		queue = world.getService( IOverworldContext ).entityCreationQueue;
	}

	@:u
	inline function update() {

		if ( queue.length == 0 ) return;

		for ( _ in 0...queue.length ) {

			final entityConfig = queue.pop();

			createUnitEntity( entityConfig );
		}
	}

	function createUnitEntity( entityConfig : EntityCreationConfig ) {

		trace( "creating unit entity" );

		final entity = createEntity();

		createComponenets( entityConfig, entity );
	}

	function createComponenets(
		entityConfig : EntityCreationConfig,
		entity : Entity
	) {

		if ( entityConfig.baseStats != null ) {

			if ( entityConfig.baseStats != null ) {

				addComponent( entity, ( entityConfig.baseStats.baseDefense : BaseDefenseStat ) );
				addComponent( entity, ( entityConfig.baseStats.baseHp : MaxHpBaseStat ) );
			}

			// if ()
		}
	}
}
