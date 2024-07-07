package en.comp.client.view;

import game.client.en.comp.view.EntityViewComponent;
import en.comp.client.view.animationStates.WalkAnimationState;
import en.comp.net.EntityDynamicsComponent;

class EntityAnimationController {

	var viewComponent : EntityViewComponent;
	var stateListeners : Map<AnimationKey, AnimationState> = [];

	public function new( viewComponent : EntityViewComponent ) {
		this.viewComponent = viewComponent;

		initListeners();

		viewComponent.entity.onFrame.add(() -> {
			for ( key => listener in stateListeners ) {
				if ( listener.listener() ) {
					viewComponent.view.playAnimation(
						key,
						listener.getOverrideSpeed() * viewComponent.entity.tmod
					);
				}
			}
		} );
	}

	function initListeners() {
		var animations : Data.Entity_view_animations = viewComponent.viewCdb.animations;
		if ( animations.idle != null ) {
			stateListeners[IDLE] = new AnimationState( idleListener );
		}
		if ( animations.attack_prime_idle != null ) {
			stateListeners[ATTACK_PRIME_IDLE] = new AnimationState( attackPrimeIdle );
		}
		if ( animations.attack_seco_idle != null ) {
			stateListeners[ATTACK_SECO_IDLE] = new AnimationState( attackSecoIdle );
		}
		if ( animations.walk != null ) {
			stateListeners[WALK] = new WalkAnimationState( viewComponent.entity, walkListener );
		}
	}

	inline function walkListener() : Bool {
		return viewComponent.entity.model.isMovementApplied;
	}

	inline function idleListener() : Bool {
		return !viewComponent.entity.model.isMovementApplied;
	}

	inline function attackPrimeIdle() : Bool {
		// todo
		return true;
	}

	inline function attackSecoIdle() : Bool {
		// todo
		return true;
	}
}
