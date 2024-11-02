package game.data.storage.entity.component;

import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;

abstract class EntityComponentDescription extends DescriptionBase {

	public var isReplicable( default, null ) = true;

	abstract public function buildComponent() : EntityComponent;
	abstract public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase;
}
