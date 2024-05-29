package game.net.entity;

import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	@:s var transformRepl : EntityTransformReplicator;

	final entity : OverworldEntity;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );
		this.entity = entity;

		transformRepl = new EntityTransformReplicator( this );
		transformRepl.followEntity( entity );
	}
}
