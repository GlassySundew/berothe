package game.net.entity;

import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	var transformRepl : EntityTransformReplicator;
	var componentsRepl : EntityComponentsReplicator;

	final entity : OverworldEntity;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );
		this.entity = entity;

		transformRepl = new EntityTransformReplicator( this );
		transformRepl.followEntity( entity );

		componentsRepl = new EntityComponentsReplicator( this );
		componentsRepl.followEntity( entity );
	}
}
