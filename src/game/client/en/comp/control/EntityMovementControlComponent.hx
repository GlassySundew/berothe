package game.client.en.comp.control;

import game.domain.overworld.entity.component.model.EntityModelComponent;
#if client
import core.IProperty;
import core.MutableProperty;
import dn.M;
import dn.heaps.input.ControllerAccess;
import util.Const;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.net.entity.EntityReplicator;
import game.net.entity.component.EntityDynamicsComponentReplicator;

class EntityMovementControlComponent extends EntityClientComponent {

	final entityReplicator : EntityReplicator;
	final ca : ControllerAccess<ControllerAction>;

	var dynamicsComponent : EntityDynamicsComponent;

	var model : EntityModelComponent;

	public function new( entityReplicator : EntityReplicator, ca : ControllerAccess<ControllerAction> ) {
		super();

		this.ca = ca;
		this.entityReplicator = entityReplicator;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {
				this.dynamicsComponent = dynamicsComponent;
				entity.onFrame.add( update );
			}
		);
		entity.components.onAppear(
			EntityModelComponent,
			( cl, model ) -> this.model = model
		);
	}

	function update( dt : Float, tmod : Float ) {
		var lx = ca.getAnalogValue2( MoveLeft, MoveRight );
		var ly = ca.getAnalogValue2( MoveDown, MoveUp );

		if ( Math.abs( lx ) == 1 && Math.abs( ly ) == 1 ) { // wasd cornering
			lx *= Math.cos( Const.FOURTY_FIVE_DEGREE_RAD );
			ly *= Math.sin( Const.FOURTY_FIVE_DEGREE_RAD );
		}

		var leftDist = M.dist( 0, 0, lx, ly );
		dynamicsComponent.isMovementApplied.val = leftDist >= 0.3;
		var leftAng = Math.atan2( ly, lx );

		if ( dynamicsComponent.isMovementApplied.val ) {
			var s = leftDist * model.stats.speed.amount.getValue() * tmod;
			var inputDirX = Math.cos( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			var inputDirY = -Math.sin( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			entity.transform.velX.val += inputDirX;// * Boot.inst.deltaTime * 60;
			entity.transform.velY.val += inputDirY;// * Boot.inst.deltaTime * 60;
		}
	}
}
#end
