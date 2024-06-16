package game.net.entity;

import net.NSClassMap;
import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityComponent;
import game.net.entity.EntityComponentReplicator;

class EntityComponentsReplicator extends NetNode {

	var entity : OverworldEntity;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.components.map( onComponentAdded );
		entity.components.onComponentAdded.add( onComponentAdded );
	}

	function onComponentAdded( entityComponent : EntityComponent ) {
		var replicator = entityComponent.description.buildCompReplicator( this );
		replicator.followComponent( entityComponent );
	}
}
