package game.net.entity;

import game.core.rules.overworld.entity.EntityComponent;
import net.NetNode;

abstract class EntityComponentReplicator extends NetNode {

	public function followComponent( component : EntityComponent ) {}
}
