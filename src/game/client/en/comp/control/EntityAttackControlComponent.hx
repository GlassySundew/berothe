package game.client.en.comp.control;

import game.core.rules.overworld.entity.OverworldEntity;
import dn.heaps.input.ControllerAccess;
import game.net.entity.EntityReplicator;
import game.core.rules.overworld.entity.EntityComponent;

class EntityAttackControlComponent extends EntityComponent {

	public function new(
		entityReplicator : EntityReplicator,
		ca : ControllerAccess<ControllerAction>
	) {
		super();
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		// entity.components.onAppear(
		// 	EntityDynamicsComponent,
		// 	( key, dynamicsComponent ) -> {
		// 		this.dynamicsComponent = dynamicsComponent;
		// 		entity.onFrame.add( update );
		// 	}
		// );

		// var dynamicsReplicator = entityReplicator.componentsRepl.components.get( EntityDynamicsComponentReplicator );
		// dynamicsReplicator.followedComponent.then( ( component ) -> {
		// 	var dynamics : EntityDynamicsComponent = Std.downcast( component, EntityDynamicsComponent );
		// 	isMovementAppliedSelf.subscribeProp( dynamics.isMovementApplied );
		// } );
	}
}
