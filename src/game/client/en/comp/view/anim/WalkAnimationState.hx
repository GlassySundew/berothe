package game.client.en.comp.view.anim;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import dn.M;

class WalkAnimationState extends AnimationState {

	final entity : OverworldEntity;
	final entityModel : EntityModelComponent;

	public function new( entity : OverworldEntity, listener ) {
		super( listener );

		this.entity = entity;
		entityModel = entity.components.get( EntityModelComponent );
	}

	override function getSpeed() : Float {
		return M.dist( 0, 0, entity.transform.velX, entity.transform.velY );
	}
}
