package game.core.rules.overworld.entity.component;

import core.MutableProperty;
import dn.M;
import signals.Signal;

class EntityDynamicsComponent extends EntityComponent {

	public final isMovementApplied : MutableProperty<Bool> = new MutableProperty( false );

	public final onMove : Signal = new Signal();
	public final isResting : MutableProperty<Bool> = new MutableProperty();

	var onMoveInvalidate = true;

	public inline function invalidateMove() {
		onMoveInvalidate = true;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.onFrame.add( onFrame );

		entity.transform.x.addOnValue(
			( oldVal ) -> {
				onMoveInvalidate = true;
			}
		);
		entity.transform.y.addOnValue(
			( oldVal ) -> {
				onMoveInvalidate = true;
			}
		);
		entity.transform.z.addOnValue(
			( oldVal ) -> {
				onMoveInvalidate = true;
			}
		);
	}

	function onFrame( tmod : Float ) {
		if ( M.fabs( entity.transform.velX.val ) < 0.0005 * tmod ) {
			entity.transform.velX.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		if ( M.fabs( entity.transform.velY.val ) < 0.0005 * tmod ) {
			entity.transform.velY.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		if ( M.fabs( entity.transform.velZ.val ) < 0.0005 * tmod ) {
			entity.transform.velZ.val = 0;
		} else {
			onMoveInvalidate = true;
		}

		isResting.val = !onMoveInvalidate;

		if ( onMoveInvalidate ) {
			onMove.dispatch();
			onMoveInvalidate = false;
		}
	}
}
