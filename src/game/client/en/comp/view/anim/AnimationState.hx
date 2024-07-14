package game.client.en.comp.view.anim;

class AnimationState {

	public final listener : Void -> Bool;

	public function getSpeed() : Float {
		return 1.;
	}

	public inline function new( listener : Void -> Bool ) {
		this.listener = listener;
	}
}
