package en.comp.client.view.animationStates;

import en.comp.net.EntityDynamicsComponent;
import dn.M;

class WalkAnimationState extends AnimationState {

	var entity : Entity;
	var dynamics : EntityDynamicsComponent;

	public function new( entity : Entity, listener ) {
		super( listener );
		this.entity = entity;
		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, component ) -> dynamics = component
		);
	}

	override function getOverrideSpeed() : Float {
		var posProv = dynamics.entityPositionProvider.toResult();
		return M.dist( 0, 0, posProv.velX, posProv.velY );
	}
}
