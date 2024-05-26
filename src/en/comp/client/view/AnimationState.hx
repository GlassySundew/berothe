package en.comp.client.view;

import en.comp.client.EntityViewComponent.AnimationKey;

class AnimationState {

	public final listener : Void -> Bool;

	public function getOverrideSpeed() : Float {
		return -1.;
	}

	public inline function new( listener : Void -> Bool ) {
		this.listener = listener;
	}
}
