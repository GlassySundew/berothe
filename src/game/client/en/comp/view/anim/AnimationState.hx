package game.client.en.comp.view.anim;

import plugins.bodyparts_animations.src.anim.FBFAnimationContainer;

class AnimationState {

	public final listener : Void -> Bool;

	public inline function new( listener : Void -> Bool ) {
		this.listener = listener;
	}

	public function getSpeed() : Float {
		return 1.;
	}

	public function playedOnContainer( animationContainer : FBFAnimationContainer ) {}
}
