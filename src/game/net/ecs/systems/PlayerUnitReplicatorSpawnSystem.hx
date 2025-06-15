package game.net.ecs.systems;

import echoes.Entity;
import echoes.System;
import game.domain.SystemPriority;
import game.domain.overworld.IOverworldContext;
import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.ecs.components.units.UnitTags.UnitSpawnRequest;
import game.net.location.ILocationReplicatorContext;
import game.net.ecs.components.UnitTags.PlayerTag;

@:priority( SystemPriority.NETWORK )
class PlayerUnitReplicatorSpawnSystem extends System {

	final context : IOverworldContext;
	final replContext : ILocationReplicatorContext;

	public function new( world, ?priority ) {
		super( world, priority );

		context = world.getService( IOverworldContext );
		replContext = world.getService( ILocationReplicatorContext );
	}

	@:upd
	inline function update( comp : UnitSpawnRequest, entity : Entity ) {

		processPlayerSpawn( context.entitySpawnConfigs.get( comp.configId ), entity );
	}

	function processPlayerSpawn( entitySpawnConfig : EntityCreationConfig, entity : Entity ) {

		if ( entitySpawnConfig.clientController == null ) return;

		replContext.cliCons.add( entitySpawnConfig.clientController );
		final cliConIdx = replContext.cliCons.length - 1;
		addComponent( entity, ( { replicatorId : cliConIdx } : PlayerTag ) );
	}
}
