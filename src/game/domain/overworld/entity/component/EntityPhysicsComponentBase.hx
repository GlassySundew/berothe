package game.domain.overworld.entity.component;

import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IPhysicsEngine;

abstract class EntityPhysicsComponentBase extends EntityComponent {

	var physics : IPhysicsEngine;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		physics = location.physics;
	}
}
