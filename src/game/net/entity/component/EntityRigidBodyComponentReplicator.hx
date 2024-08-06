package game.net.entity.component;

import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityRigidBodyComponentReplicator extends EntityComponentReplicatorBase {

	override function followComponentClient( entity : OverworldEntity ) {
		super.followComponentClient( entity );

		followedComponent.then(
			component -> {
				var rbComponent = Std.downcast( component, EntityRigidBodyComponent );
				rbComponent.rigidBodyFuture.then(
					rigidBody -> {
						if ( rbComponent.isOwned ) return;
						rigidBody.setGravityScale( 0 );
					}
				);
			}
		);
	}
}
