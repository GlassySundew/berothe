package game.client.en.comp.view.anim;

import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import dn.M;

class WalkAnimationState extends AnimationState {

	final entity : OverworldEntity;

	public function new( entity : OverworldEntity, listener ) {
		super( listener );

		this.entity = entity;
	}

	override function getSpeed() : Float {
		/** todo make functionality to get entity walking speed (via walking
			archetype that is affected with, say, speed potion or whatever other speed modificator)
		**/
		return M.dist( 0, 0, entity.transform.velX, entity.transform.velY ) * .1;
	}
}
