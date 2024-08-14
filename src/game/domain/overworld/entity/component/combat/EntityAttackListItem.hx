package game.domain.overworld.entity.component.combat;

import signals.Signal;
import game.domain.overworld.location.Location;
import game.data.storage.entity.body.properties.AttackListItem;
import game.physics.oimo.AttackTweenBoxCastEmitter;
import oimo.collision.geometry.BoxGeometry;
import game.data.storage.entity.body.view.AttackTranslationTween;

class EntityAttackListItem {

	public final desc : AttackListItem;

	public final onAttackPerformed = new Signal();

	var emitter : AttackTweenBoxCastEmitter;
	var entity : OverworldEntity;

	public function new( desc : AttackListItem ) {
		this.desc = desc;
	}

	public function attack( ignoreCooldown = false ) {
		if ( !ignoreCooldown && emitter.isOnCooldown() ) return;
		if ( emitter.isInAction() ) return;

		emitter.performCasting();
		onAttackPerformed.dispatch();
	}

	public inline function isOnCooldown() {
		return emitter.isOnCooldown();
	}

	public inline function isAttacking() : Bool {
		return emitter.isInAction();
	}

	public inline function getCurrentAttackTime() : Float {
		return emitter.getCurrentTimelapseRatio();
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		var rigidBodyComp = entity.components.get( EntityRigidBodyComponent );
		rigidBodyComp.rigidBodyFuture.then( rigidBody -> {
			emitter = new AttackTweenBoxCastEmitter(
				desc,
				rigidBody.transform,
				location.physics
			);
			entity.onFrame.add( update );

			emitter.getCallbackContainer().beginCB.add(
				( contact ) -> {
					trace(
						contact._b1._shapeList.getCollisionGroup(),
						contact._b1._shapeList.getCollisionMask(),
						Math.random()
					);
				} );
		} );
	}

	inline function update( dt, tmod ) {
		emitter.update( dt, tmod );
	}
}
