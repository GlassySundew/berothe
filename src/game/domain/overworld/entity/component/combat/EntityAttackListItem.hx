package game.domain.overworld.entity.component.combat;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.domain.overworld.location.Location;
import game.data.storage.entity.body.properties.AttackListItem;
import game.physics.oimo.AttackTweenBoxCastEmitter;
import oimo.collision.geometry.BoxGeometry;
import game.data.storage.entity.body.view.AttackTranslationTween;

class EntityAttackListItem {

	public final desc : AttackListItem;
	public final onAttackPerformed = new Signal();
	public final isRaised : MutableProperty<Bool> = new MutableProperty();

	final attackRange : MutableProperty<Float> = new MutableProperty();

	var emitter : AttackTweenBoxCastEmitter;
	var entity : OverworldEntity;
	var damageAmount : Float;

	public function new( desc : AttackListItem ) {
		this.desc = desc;
	}

	public function attack( ignoreCooldown = false ) {
		if ( !ignoreCooldown && emitter.isOnCooldown() ) return;
		if ( emitter.isInAction() ) return;

		isRaised.val = true;
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

	public inline function setAttack( amount : Float ) {
		damageAmount = amount;
	}

	#if !debug inline #end
	public function setRange( amount : Float ) {
		attackRange.val = amount;
	}

	function onAttachedToLocation( location : Location ) {
		entity.components.onAppear(
			EntityRigidBodyComponent,
			( cl, rigidBodyComp ) -> {
				rigidBodyComp.rigidBodyFuture.then( rigidBody -> {
					emitter = new AttackTweenBoxCastEmitter(
						desc,
						rigidBody.transform,
						location.physics
					);
					attackRange.addOnValueImmediately(
						( old, newVal ) -> emitter.setAttackRange( newVal )
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
		);
	}

	inline function update( dt, tmod ) {
		emitter.update( dt, tmod );
	}
}
