package game.client.en.comp;

import hxd.Key;
#if client
import dn.M;
import dn.heaps.input.ControllerAccess;
import util.Const;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;

class EntityMovementControlComponent extends EntityComponent {

	public var leftPushed( default, null ) : Bool;

	var ca : ControllerAccess<ControllerAction>;
	var dynamicsComponent : EntityDynamicsComponent;

	// TODO temp
	var speed = 8;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		// TODO надо завязать leftPushed на проперти, которая реплицируется по сети

		ca = Main.inst.controller.createAccess();
		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {
				this.dynamicsComponent = dynamicsComponent;
				entity.onFrame.add( update );
			}
		);
	}

	function update( tmod : Float ) {
		var lx = ca.getAnalogValue2( MoveLeft, MoveRight );
		var ly = ca.getAnalogValue2( MoveDown, MoveUp );

		if ( Math.abs( lx ) == 1 && Math.abs( ly ) == 1 ) { // wasd cornering
			lx *= Math.cos( Const.FOURTY_FIVE_DEGREE_RAD );
			ly *= Math.sin( Const.FOURTY_FIVE_DEGREE_RAD );
		}

		var leftDist = M.dist( 0, 0, lx, ly );
		leftPushed = leftDist >= 0.3;
		var leftAng = Math.atan2( ly, lx );

		if ( leftPushed ) {
			var s = leftDist * speed * Main.inst.tmod;
			entity.transform.velX.val += Math.cos( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			entity.transform.velY.val += -Math.sin( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;


			// if ( lx < -0.3 && M.fabs( ly ) < 0.6 ) entity.model.dir.val = Left;
			// else if ( ly < -0.3 && M.fabs( lx ) < 0.6 ) entity.model.dir.val = Bottom;
			// else if ( lx > 0.3 && M.fabs( ly ) < 0.6 ) entity.model.dir.val = Right;
			// else if ( ly > 0.3 && M.fabs( lx ) < 0.6 ) entity.model.dir.val = Top;

			// if ( lx > 0.3 && ly > 0.3 ) entity.model.dir.val = TopRight;
			// else if ( lx < -0.3 && ly > 0.3 ) entity.model.dir.val = TopLeft;
			// else if ( lx < -0.3 && ly < -0.3 ) entity.model.dir.val = BottomLeft;
			// else if ( lx > 0.3 && ly < -0.3 ) entity.model.dir.val = BottomRight;
		}
	}
}
#end
