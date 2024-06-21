package game.net.entity;

import game.core.rules.overworld.entity.component.EntityDynamicsComponent;
import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;

class EntityComponentReplicatorFactory {

	public static function fromComponent( component : EntityComponent, ?parent : NetNode ) {

		// switch component.classType {
		// 	case EntityDynamicsComponent: new Entity
		// 	case e: trace( 'Component $e is not supported for network replication' );
		// }
	}
}
