package game.domain.overworld.entity.component.ai;

import game.domain.overworld.location.Location;

class EntityAIComponent extends EntityComponent {

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		
	}
}
