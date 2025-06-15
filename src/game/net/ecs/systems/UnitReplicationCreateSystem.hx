package game.net.ecs.systems;

import game.net.ecs.components.UnitTags.UnitRepl;
import game.net.entity.EntityReplicator;
import game.net.location.ILocationReplicatorContext;
import game.domain.overworld.IOverworldContext;
import echoes.Entity;
import echoes.System;
import game.domain.SystemPriority;
import game.domain.overworld.ecs.components.units.UnitTags.UnitSpawnRequest;
import game.domain.overworld.ecs.components.units.UnitDynamics;

@:priority( SystemPriority.NETWORK )
class UnitReplicationCreateSystem extends System {

	final replContext : ILocationReplicatorContext;

	public function new( world, ?priority ) {
		super( world, priority );

		replContext = world.getService( ILocationReplicatorContext );
	}

	@:upd
	inline function update( comp : UnitSpawnRequest, entity : Entity ) {

		final entityReplicator = new EntityReplicator();
		replContext.entityReplicators.add( entityReplicator );
		final idx = replContext.entityReplicators.length - 1;

		addComponent( entity, ( { replicatorId : idx } : UnitRepl ) );
	}
}
