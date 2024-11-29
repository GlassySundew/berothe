package game.domain.overworld.entity.component;

import haxe.Timer;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.data.storage.DataStorage;
import game.domain.overworld.location.physics.RayCastHit;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.physics.oimo.RayCastCallback;
import game.data.storage.entity.body.properties.EntityFlyDescription;
import rx.disposables.Composite;

class EntityFlyComponent extends EntityComponent {

	var desc( get, never ) : EntityFlyDescription;
	inline function get_desc() : EntityFlyDescription {
		return Std.downcast( description, EntityFlyDescription );
	}

	var modelComp : EntityModelComponent;
	var rigidBodyComp : EntityRigidBodyComponent;

	var oscilaltion : Float;
	var isSuspended = false;

	final sub = Composite.create();

	public function suspend() {
		isSuspended = true;
	}

	public function resume() {
		isSuspended = false;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		sub.add( entity.location.addOnValueImmediately( ( oldLoc, newLoc ) -> {
			if ( newLoc == null ) return;

			var dynamics = entity.components.get( EntityDynamicsComponent );
			if ( dynamics == null ) return;

			entity.components.onAppear(
				EntityRigidBodyComponent,
				( _, rbComp ) -> {
					// rbComp.rigidBody.setGravityScale(
					// 	DataStorage.inst.rule.flyingEntityGravityScale
					// );
				} );

			entity.components.onAppear(
				EntityModelComponent,
				( _, modelComp ) -> {
					this.modelComp = modelComp;
				}
			);

			entity.components.onAppear(
				EntityRigidBodyComponent,
				( _, rigidBodyComp ) -> {
					this.rigidBodyComp = rigidBodyComp;
				}
			);

			var standRayCastCallback = new RayCastCallback();
			standRayCastCallback.onShapeCollide.add( onRayCollide );

			var rbdesc = entity.desc.getBodyDescription().rigidBodyTorsoDesc;
			var offsetZ = rbdesc.offsetZ;

			dynamics.onMove.add(() -> {
				if ( isSuspended ) return;

				oscilaltion = Math.sin( Timer.stamp() * desc.frequency * 2 * Math.PI ) * desc.amplitude;

				var start = entity.transform.getPosition();
				start.z += offsetZ;
				var end = start.clone();
				end.z -= desc.distance + oscilaltion;

				newLoc.physics.rayCast( start, end, standRayCastCallback );
			} );
		} ) );

		entity.disposed.then( _ -> sub.unsubscribe() );
	}

	inline function onRayCollide( shape : IRigidBodyShape, rayCastHit : RayCastHit ) {
		if (
			rigidBodyComp != null
			&& shape.getCollisionGroup() & rigidBodyComp.torsoShape.getCollisionMask() == 0
		) return;

		#if server
		if (
			!modelComp?.isSleeping.val
			&& rayCastHit.fraction < 1
		) {
			var tmod = game.net.server.GameServer.inst.tmod;

			var vertVel = entity.transform.velZ.val;
			var force = (( desc.distance + oscilaltion ) * ( 1 - rayCastHit.fraction ) ) * 0.2 - vertVel * 0.1;

			entity.transform.velZ.val += force * tmod;
		}
		#end
	}
}
