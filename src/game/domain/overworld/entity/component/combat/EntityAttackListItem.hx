package game.domain.overworld.entity.component.combat;

import game.physics.oimo.EntityRigidBodyProps;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.domain.overworld.location.Location;
import game.data.storage.entity.body.properties.AttackListItemVO;
import game.physics.oimo.AttackTweenBoxCastEmitter;
import oimo.collision.geometry.BoxGeometry;
import game.data.storage.entity.body.view.AttackTranslationTween;

class EntityAttackListItem {

	public final desc : AttackListItemVO;
	public final onAttackPerformed = new Signal();
	public final isRaised : MutableProperty<Bool> = new MutableProperty();

	final attackRange : MutableProperty<Float> = new MutableProperty();
	final emitter : MutableProperty<AttackTweenBoxCastEmitter> = new MutableProperty();

	var entity : OverworldEntity;

	public function new( desc : AttackListItemVO ) {
		this.desc = desc;
	}

	public function dispose() {
		emitter?.val?.dispose();
	}

	public function attack( ignoreCooldown = false ) {
		if ( !ignoreCooldown && emitter.val.isOnCooldown() ) return;
		if ( emitter.val == null || emitter.val.isInAction() ) return;

		isRaised.val = true;
		emitter.val.performCasting();
		onAttackPerformed.dispatch();
	}

	public inline function isOnCooldown() {
		return emitter.val.isOnCooldown();
	}

	public inline function isAttacking() : Bool {
		return emitter.val.isInAction();
	}

	public inline function getCurrentAttackTime() : Float {
		return emitter.val.getCurrentTimelapseRatio();
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.location.onAppear( onAttachedToLocation );
		entity.disposed.then( _ -> dispose() );
	}

	#if !debug inline #end
	public function setRange( amount : Float ) {
		attackRange.val = amount;
	}

	#if !debug inline #end
	public function claimOwnage() {
		emitter.onAppear( emitter -> {
			emitter.getCallbackContainer().beginCB.add(
				( contact ) -> {
					var maybeEnemy1 = Std.downcast( contact._b1.userData, EntityRigidBodyProps )?.entity;
					var maybeEnemy2 = Std.downcast( contact._b2.userData, EntityRigidBodyProps )?.entity;
					if ( maybeEnemy1 != null && maybeEnemy1 != entity ) {
						EntityDamageService.entityDamageWithAttackListItem( entity, maybeEnemy1, desc );
						emitter.removeEmitter();
						return;
					}
					if ( maybeEnemy2 != null && maybeEnemy2 != entity ) {
						EntityDamageService.entityDamageWithAttackListItem( entity, maybeEnemy2, desc );
						emitter.removeEmitter();
						return;
					}
				} );
		} );
	}

	function onAttachedToLocation( location : Location ) {
		entity.components.onAppear(
			EntityRigidBodyComponent,
			( cl, rigidBodyComp ) -> {
				rigidBodyComp.rigidBodyFuture.then( rigidBody -> {
					emitter.val = new AttackTweenBoxCastEmitter(
						desc,
						rigidBody.transform,
						location.physics
					);
					attackRange.addOnValueImmediately(
						( old, newVal ) -> emitter.val.setAttackRange( newVal )
					);

					entity.onFrame.add( update );
				} );
			}
		);
	}

	inline function update( dt, tmod ) {
		emitter.val.update( dt, tmod );
	}
}
