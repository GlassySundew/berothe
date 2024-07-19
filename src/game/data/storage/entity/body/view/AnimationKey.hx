package game.data.storage.entity.body.view;

import util.Assert;

enum abstract AnimationKey( String ) from String to String {

	var IDLE = "idle";
	var WALK = "walk";
	var ATTACK_PRIME_IDLE = "attack_prime_idle";
	var ATTACK_PRIME_ATTACK = "attack_prime_attack";
	var ATTACK_SECO_IDLE = "attack_seco_idle";
	var ATTACK_SECO_ATTACK = "attack_seco_attack";

	public inline static function fromCdb( animation : Data.EntityViewState ) : AnimationKey {
		var key = switch animation.id {
			case idle: IDLE;
			case walk: WALK;
			case attack_prime_idle: ATTACK_PRIME_IDLE;
			case attack_prime_attack: ATTACK_PRIME_ATTACK;
			case attack_seco_idle: ATTACK_SECO_IDLE;
			case attack_seco_attack: ATTACK_SECO_ATTACK;
		}

		Assert.notNull( key, "failed to recognize animation: " + animation );

		return key;
	}

	#if !debug inline #end
	public static function fromString( animation : String ) : AnimationKey {
		return fromCdb( cast animation );
	}
}
