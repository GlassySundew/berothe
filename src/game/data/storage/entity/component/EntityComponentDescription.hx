package game.data.storage.entity.component;

import net.NetNode;
import game.net.entity.EntityComponentReplicator;
import game.core.rules.overworld.entity.EntityComponent;

abstract class EntityComponentDescription {

	abstract public function buildComponennt() : EntityComponent;
	abstract public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator;
}
