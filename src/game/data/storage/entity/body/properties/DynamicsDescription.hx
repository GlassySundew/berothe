package game.data.storage.entity.body.properties;

import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.net.entity.component.EntityDynamicsComponentReplicator;
import game.data.storage.entity.component.EntityComponentDescription;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.EntityDynamicsComponent;

class DynamicsDescription extends EntityComponentDescription {

	public function new( id : String ) {
		super( id );
	}

	public function buildComponennt() : EntityComponent {
		return new EntityDynamicsComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntityDynamicsComponentReplicator( parent );
	}
}
