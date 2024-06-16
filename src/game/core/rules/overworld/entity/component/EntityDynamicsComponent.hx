package game.core.rules.overworld.entity.component;

import dn.M;
import signals.Signal;

class EntityDynamicsComponent extends EntityComponent {

	public var onMove( default, null ) : Signal = new Signal();

	var onMoveInvalidate = false;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.onFrame.add( onFrame );

		entity.transform.x.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.transform.x.val - oldVal ) > 0 )
				onMoveInvalidate = true
		);
		entity.transform.y.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.transform.y.val - oldVal ) > 0 )
				onMoveInvalidate = true
		);
		entity.transform.z.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.transform.z.val - oldVal ) > 0 )
				onMoveInvalidate = true
		);
	}

	function onFrame( tmod : Float ) {
		if ( M.fabs( entity.transform.velX.val ) < 0.0005 * tmod ) {
			entity.transform.velX.val = 0;
		} else
			onMoveInvalidate = true;

		if ( M.fabs( entity.transform.velY.val ) < 0.0005 * tmod ) {
			entity.transform.velY.val = 0;
		} else
			onMoveInvalidate = true;

		if ( M.fabs( entity.transform.velZ.val ) < 0.0005 * tmod ) {
			entity.transform.velZ.val = 0;
		} else
			onMoveInvalidate = true;

		if ( onMoveInvalidate ) {
			onMove.dispatch();
			onMoveInvalidate = false;
		}
	}
}
