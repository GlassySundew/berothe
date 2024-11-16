package game.domain.overworld.entity.component;

import rx.disposables.Composite;
import core.MutableProperty;
import dn.M;
import signals.Signal;

class EntityDynamicsComponent extends EntityComponent {

	public final isMovementApplied : MutableProperty<Bool> = new MutableProperty( false );

	public final onMove : Signal = new Signal();
	public final isResting : MutableProperty<Bool> = new MutableProperty();

	var onMoveInvalidate = true;

	var subscription : Composite;

	public inline function invalidateMove() {
		onMoveInvalidate = true;
	}

	override function claimOwnage() {
		super.claimOwnage();
		
		subscription?.unsubscribe();
		subscription = Composite.create();

		subscription.add( entity.onFrame.add( onFrame ) );

		subscription.add( entity.transform.x.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
		subscription.add( entity.transform.y.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
		subscription.add( entity.transform.z.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
		subscription.add( entity.transform.rotationX.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
		subscription.add( entity.transform.rotationY.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
		subscription.add( entity.transform.rotationZ.addOnValue(
			( _, _ ) -> {
				onMoveInvalidate = true;
			}
		) );
	}

	function onFrame( dt, tmod : Float ) {
		if ( M.fabs( entity.transform.velX.val ) < 0.001 * tmod ) {
			entity.transform.velX.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		if ( M.fabs( entity.transform.velY.val ) < 0.001 * tmod ) {
			entity.transform.velY.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		if ( M.fabs( entity.transform.velZ.val ) < 0.001 * tmod ) {
			entity.transform.velZ.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		isResting.val = !onMoveInvalidate;

		if ( onMoveInvalidate ) {
			onMoveInvalidate = false;
			onMove.dispatch();
		}
	}
}
