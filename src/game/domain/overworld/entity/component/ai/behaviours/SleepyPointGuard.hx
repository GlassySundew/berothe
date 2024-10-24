package game.domain.overworld.entity.component.ai.behaviours;

import game.physics.oimo.EntityRigidBodyProps;
import util.Assert;
import rx.disposables.ISubscription;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.component.model.EntityModelComponent;

class SleepyPointGuard extends EntityBehaviourBase {

	final triggerId : String;

	public function new( triggerId : String ) {
		super();
		this.triggerId = triggerId;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
	}

	override function onAttachedToLocation( location : Location ) {
		sleep();
		entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				var sub : ISubscription = null;
				sub = modelComp.isSleeping.addOnValue(
					( _, val ) -> //
						if ( !val ) {
							seekForEnemy();
							sub.unsubscribe();
						}
				);

				if ( triggerId == null || location.triggers[triggerId] == null ) return;

				var sub : ISubscription = null;
				sub = location.triggers[triggerId].cb.postSolveCB.add( cb -> {
					inline function someEntityTriggered( enemyMaybe : OverworldEntity ) {
						if ( modelComp.isEnemy( enemyMaybe ) ) {
							sub.unsubscribe();
							wake();
						}
					}
					if ( cb._b1.userData is EntityRigidBodyProps ) {
						someEntityTriggered( Std.downcast( cb._b1.userData, EntityRigidBodyProps ).entity );
					}
					if ( cb._b2.userData is EntityRigidBodyProps ) {
						someEntityTriggered( Std.downcast( cb._b2.userData, EntityRigidBodyProps ).entity );
					}
				} );
			}
		);
	}
}
