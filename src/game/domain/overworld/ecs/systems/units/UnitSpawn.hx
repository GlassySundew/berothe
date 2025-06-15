package game.domain.overworld.ecs.systems.units;

import echoes.Entity;
import echoes.System;
import hx.concurrent.collection.Collection;
import hx.concurrent.collection.OrderedCollection;
import game.domain.SystemPriority;
import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.ecs.components.units.BaseUnitStats.BaseDefenseStat;
import game.domain.overworld.ecs.components.units.BaseUnitStats.MaxHpBaseStat;
import game.domain.overworld.ecs.components.units.UnitDynamics.MovedThisTick;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitPosition;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitVelocity;
import game.domain.overworld.ecs.components.units.UnitTags.UnitSpawnRequest;

@:priority( SystemPriority.CORE )
class UnitSpawn extends System {

	final entitySpawnConfigs : OrderedCollection<EntityCreationConfig>;

	public function new( world, ?priority ) {
		super( world, priority );

		entitySpawnConfigs = world.getService( IOverworldContext ).entitySpawnConfigs;
	}

	@:upd
	inline function update( comp : UnitSpawnRequest, entity : Entity ) {

		createUnitEntity( entitySpawnConfigs.get( comp.configId ), entity );
	}

	function createUnitEntity( entityConfig : EntityCreationConfig, entity : Entity ) {

		trace( "creating unit entity" );

		createComponents( entityConfig, entity );
	}

	function createComponents(
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

		final pos = entityConfig.position;
		addComponent( entity, ( { x : pos.x, y : pos.y, z : pos.z } : UnitPosition ) );

		if ( entityConfig.isDynamic ) {

			final vel = entityConfig.velocity;
			addComponent( entity, ( { x : vel.x, y : vel.y, z : vel.z } : UnitVelocity ) );
			addComponent( entity, ( true : MovedThisTick ) );
		}
	}
}
