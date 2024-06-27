package game.data.storage.entity.body.properties;

import net.NetNode;
import game.net.entity.EntityComponentReplicator;
import game.net.entity.component.EntityDynamicsComponentReplicator;
import game.data.storage.entity.component.EntityComponentDescription;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;

class DynamicsDescription extends EntityComponentDescription {

	public function new() {
		super( "dynamics" );
	}

	public function buildComponennt() : EntityComponent {
		return new EntityDynamicsComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return new EntityDynamicsComponentReplicator( parent );
	}
}
