package game.client.en.comp.view.anim;

import game.domain.overworld.entity.component.combat.EntityAttackListItem;
import plugins.bodyparts_animations.src.anim.FBFAnimationContainer;

class AttackAnimationState extends AnimationState {

	final attackItem : EntityAttackListItem;

	public function new( attackItem : EntityAttackListItem ) {
		super( isPlaying );
		this.attackItem = attackItem;
	}

	inline function isPlaying() : Bool {
		return attackItem.isAttacking();
	}

	override public function playedOnContainer(
		animationContainer : FBFAnimationContainer
	) {
		animationContainer.setTime( attackItem.getCurrentAttackTime() );
	}
}
