package game.domain.overworld.entity.component.ai.behaviours;

import rx.disposables.Composite;
import game.data.storage.entity.body.properties.EntityAIDescription.AIProperties;
import game.physics.oimo.EntityRigidBodyProps;
import util.Assert;
import rx.disposables.ISubscription;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.component.model.EntityModelComponent;

class SleepyPointGuard extends EntityBehaviourBase {

	final triggerId : String;

	public function new( params : AIProperties ) {
		super( params );
		this.triggerId = params.triggerId;
	}

	override function onAttachedToLocation( location : Location ) {
		super.onAttachedToLocation( location );
		sleep();
		#if client return; #end
		
		entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				var composite = Composite.create();
				var sub : ISubscription = null;
				sub = modelComp.isSleeping.addOnValue(
					( _, val ) -> //
						if ( !val ) {
							var enemy = seekForEnemy();
							if ( enemy != null ) {
								state = AGRO( enemy );
								sub.unsubscribe();
							}
						}
				);
				composite.add( sub );

				var collisionTrigger = location.getTriggerByIdent( triggerId );

				if ( triggerId == null || collisionTrigger == null ) return;

				// seeking for entity trigger on location
				var sub : ISubscription = null;
				sub = collisionTrigger.cb.postSolveCB.add( cb -> {
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
				composite.add( sub );
				entity.disposed.then( _ -> composite.unsubscribe() );
			}
		);
	}
}
