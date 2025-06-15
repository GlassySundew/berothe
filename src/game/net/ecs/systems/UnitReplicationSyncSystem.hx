package game.net.ecs.systems;

import game.net.entity.components.UnitPosReplicator;
import game.net.ecs.components.UnitTags.UnitRepl;
import game.net.location.ILocationReplicatorContext;
import echoes.Entity;
import echoes.System;
import game.domain.SystemPriority;
import game.domain.overworld.ecs.components.units.UnitDynamics.UnitPosition;
import game.domain.overworld.ecs.components.units.UnitDynamics.MovedThisTick;

/**
	model to network
**/
@:priority( SystemPriority.NETWORK )
class UnitReplicationSyncSystem extends System {

	final replContext : ILocationReplicatorContext;

	public function new( world, ?priority ) {

		super( world, priority );

		replContext = world.getService( ILocationReplicatorContext );
	}

	@:upd
	function updatePos(
		comp : UnitPosition,
		_ : MovedThisTick,
		unitRepl : UnitRepl,
		entity : Entity
	) {

		final unitRepl = replContext.entityReplicators.get( unitRepl.replicatorId );

		if ( unitRepl.pos == null )
			unitRepl.pos = new UnitPosReplicator( unitRepl );
	}
}
