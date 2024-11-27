package game.domain.overworld.entity.component;

import game.data.storage.DataStorage;
import game.net.server.GameServer;
import game.domain.overworld.location.physics.RayCastHit;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.physics.oimo.RayCastCallback;
import game.data.storage.entity.body.properties.EntityFlyingDescription;
import rx.disposables.Composite;

class EntityFlyComponent extends EntityComponent {

	var desc( get, never ) : EntityFlyingDescription;
	inline function get_desc() : EntityFlyingDescription {
		return Std.downcast( description, EntityFlyingDescription );
	}

	final sub = Composite.create();

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		sub.add( entity.location.addOnValueImmediately( ( oldLoc, newLoc ) -> {
			if ( newLoc == null ) return;

			var dynamics = entity.components.get( EntityDynamicsComponent );
			if ( dynamics == null ) return;

			entity.components.onAppear(
				EntityRigidBodyComponent,
				( _, rbComp ) -> {
					rbComp.rigidBody.setGravityScale(
						DataStorage.inst.rule.flyingEntityGravityScale
					);
				} );

			var standRayCastCallback = new RayCastCallback();
			standRayCastCallback.onShapeCollide.add( onRayCollide );

			var rbdesc = entity.desc.getBodyDescription().rigidBodyTorsoDesc;
			var offset = rbdesc.offsetZ;

			dynamics.onMove.add(() -> {
				var start = entity.transform.getPosition();
				start.z += offset;
				var end = start.clone();
				end.z -= desc.distance;

				newLoc.physics.rayCast( start, end, standRayCastCallback );
			} );
		} ) );

		entity.disposed.then( _ -> sub.unsubscribe() );
	}

	inline function onRayCollide( shape : IRigidBodyShape, rayCastHit : RayCastHit ) {
		// GameServer.inst.tmod
		trace( rayCastHit.fraction );
		if ( rayCastHit.fraction < 1 ) {
			entity.transform.velZ.val += ( 1 - rayCastHit.fraction ) * 2;
		}
	}
}
