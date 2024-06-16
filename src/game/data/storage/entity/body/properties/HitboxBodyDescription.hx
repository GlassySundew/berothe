package game.data.storage.entity.body.properties;

import net.NetNode;
import game.net.entity.EntityComponentReplicator;
import game.core.rules.overworld.entity.EntityComponent;

class HitboxBodyDescription extends VolumetricBodyDescriptionBase {

	public function buildComponennt() : EntityComponent {
		return null;
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return null;
	}
}
