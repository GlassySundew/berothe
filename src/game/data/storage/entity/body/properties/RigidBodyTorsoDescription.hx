package game.data.storage.entity.body.properties;

import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.data.storage.entity.body.properties.VolumetricBodyDescriptionBase;
import game.net.entity.EntityComponentReplicator;

class RigidBodyTorsoDescription extends VolumetricBodyDescriptionBase {

	public function buildComponennt() : EntityComponent {
		return new EntityRigidBodyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return null;
	}
}
