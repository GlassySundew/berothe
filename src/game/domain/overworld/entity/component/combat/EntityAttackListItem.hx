package game.domain.overworld.entity.component.combat;

import rx.Subscription;
import rx.disposables.Composite;
import rx.disposables.ISubscription;
import game.domain.overworld.location.physics.Types.EntityCollisionsService;
import game.physics.oimo.EntityRigidBodyProps;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.domain.overworld.location.OverworldLocationMain;
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

	var isOwned = false;

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

	#if !debug inline #end
	public function isAttacking() : Bool {
		return emitter.val?.isInAction();
	}

	public inline function getCurrentAttackTime() : Float {
		return emitter.val.getCurrentTimelapseRatio();
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
		entity.location.addOnValueImmediately( onAttachedToLocation );
		entity.disposed.then( _ -> dispose() );

		entity.components.onAppear(
			EntityRigidBodyComponent,
			( cl, rigidBodyComp ) -> {
				rigidBodyComp.rigidBodyFuture.then( rigidBody -> {
					emitter.val = new AttackTweenBoxCastEmitter(
						desc,
						rigidBody.transform
					);
					attackRange.addOnValueImmediately(
						( old, newVal ) -> emitter.val.setAttackRange( newVal )
					);

					entity.onFrame.add( update );
				} );
				if ( isOwned ) claimOwnage();
			}
		);
	}

	#if !debug inline #end
	public function setRange( amount : Float ) {
		attackRange.val = amount;
	}

	#if !debug inline #end
	public function claimOwnage() {
		isOwned = true;
		emitter.onAppear( emitter -> {
			emitter.getCallbackContainer().beginCB.add(
				EntityCollisionsService.unwrapContact.bind(
					_,
					( entity1, entity2 ) -> {
						var enemy = //
							if ( entity1 != null && entity1 != this.entity ) {
								entity1;
							} else if ( entity2 != null && entity2 != this.entity ) {
								entity2;
							} else null;
						if ( enemy == null ) return;
						EntityDamageService.entityDamageWithAttackListItem( entity, enemy, desc );
						emitter.removeEmitter();
					}
				) );
		} );
	}

	function onAttachedToLocation( oldLoc : OverworldLocationMain, location : OverworldLocationMain ) {
		if ( location == null ) return;

		emitter.val?.removeEmitter();
		// emitter.onAppear( emitter -> emitter.attachPhysics( location.physics ) );
	}

	inline function update( dt, tmod ) {
		emitter.val.update( dt, tmod );
	}
}
