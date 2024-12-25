package game.domain.overworld.entity.component.ai;

import util.Assert;
import game.data.storage.entity.body.properties.EntityAIDescription;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;
import game.domain.overworld.location.Location;

class EntityAIComponent extends EntityComponent {

	var desc( get, never ) : EntityAIDescription;
	inline function get_desc() : EntityAIDescription {
		return Std.downcast( description, EntityAIDescription );
	}

	var behaviour : EntityBehaviourBase;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		#if server
		behaviour = BehaviourFactory.fromDesc( desc );
		Assert.notNull( behaviour );
		behaviour.attachToEntity( entity );
		#end
	}
}
