package game.net.entity;

import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	@:s var transformRepl : EntityTransformReplicator;

	public function new( ?parent ) {
		super( parent );

		transformRepl = new EntityTransformReplicator( this );
	}

	public function setEntity(entity:OverworldEntity) {
		transformRepl.setEntity(entity);
	} 
}
