package game.domain.overworld.entity.component.ai.behaviours;

import game.net.client.GameClient;
import dn.M;
import hxd.Timer;
import dn.Cooldown;
import game.domain.overworld.location.Location;

class RandomRoaming extends EntityBehaviourBase {

	final pickDist : Float = 20;
	final pointLifeSec : Float = 4;

	var point : { x : Float, y : Float };
	final cd : Cooldown = new Cooldown( Timer.wantedFPS );

	override function dispose( _ : Bool ) {
		cd.reset();
	}

	override function update( dt : Float, tmod : Float ) {
		super.update( dt, tmod );

		#if client return; #end
		
		switch state {
			case AGRO( enemy ): return;
			default:
		}

		cd.update( tmod );

		if ( point == null ) repickPoint();

		walkTowardsPoint( point.x, point.y, tmod );

		if ( M.dist(
			point.x,
			point.y,
			entity.transform.x,
			entity.transform.y
		) <= 3 ) {
			repickPoint();
		}
		dynamics.isMovementApplied.val = true;
	}

	inline function repickPoint() {
		point = {
			x : entity.transform.x.val + hxd.Math.random( pickDist * 2 ) - pickDist,
			y : entity.transform.y.val + hxd.Math.random( pickDist * 2 ) - pickDist
		};
		cd.unset( "pickPoint" );
		cd.setS(
			"pickPoint",
			pointLifeSec,
			() -> repickPoint()
		);
	}
}
