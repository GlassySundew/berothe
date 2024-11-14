package game.domain.overworld.entity.component;

import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.IPhysicsEngine;

abstract class EntityPhysicsComponentBase extends EntityComponent {

	var physics : IPhysicsEngine;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.location.addOnValueImmediately( onAttachedToLocation );
	}

	function onAttachedToLocation( oldLoc : Location, location : Location ) {
		if ( location == null ) return;
		physics = location.physics;
	}
}
