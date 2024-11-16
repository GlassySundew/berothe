package game.client.en.comp.view.anim;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import dn.M;

class WalkAnimationState extends AnimationState {

	final entity : OverworldEntity;

	var speed : Float;

	public function new(
		entity : OverworldEntity,
		listener,
		ignoreStats
	) {
		super( listener, ignoreStats );

		this.entity = entity;
		entity.components.onAppear(
			EntityModelComponent,
			( cl, comp ) -> {
				comp.stats.speed.amount.addOnValueImmediately( ( oldV, newV ) -> speed = newV );
			}
		);
	}

	override function getSpeed() : Float {
		return
			isAffectedByStats ? speed : 1;
	}
}
