package game.net.entity.component;

import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import game.domain.overworld.entity.EntityComponent;

class EntityDynamicsComponentReplicator extends EntityComponentReplicatorBase {

	@:s public var isMovementApplied : NSMutableProperty<Bool> = new NSMutableProperty();

	override function followComponentClient( entity : OverworldEntity ) {
		super.followComponentClient( entity );
		followedComponent.then( ( component ) -> {
			networkToModel( Std.downcast( component, EntityDynamicsComponent ) );
			modelToNetwork( Std.downcast( component, EntityDynamicsComponent ) );
		} );
	}

	override function followComponentServer( component : EntityComponent ) {
		super.followComponentServer( component );
		modelToNetwork( Std.downcast( component, EntityDynamicsComponent ) );
		networkToModel( Std.downcast( component, EntityDynamicsComponent ) );
	}

	function modelToNetwork( dynamics : EntityDynamicsComponent ) {
		dynamics.isMovementApplied.subscribeProp( isMovementApplied );
	}

	function networkToModel( dynamics : EntityDynamicsComponent ) {
		isMovementApplied.subscribeProp( dynamics.isMovementApplied );
	}
}
