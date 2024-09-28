package game.data.storage.entity.body.view;

import util.Assert;

enum abstract AnimationKey( String ) from String to String {

	var IDLE;
	var WALK;
	var ATTACK_RIGHT_IDLE;
	var ATTACK_RIGHT_RAISED;
	var ATTACK_RIGHT_ATTACK;
	var ATTACK_LEFT_IDLE;
	var ATTACK_LEFT_RAISED;
	var ATTACK_LEFT_ATTACK;

	public inline static function fromCdb( animation : Data.EntityViewState ) : AnimationKey {
		var key = switch animation.id {
			case idle: IDLE;
			case walk: WALK;
			case attack_right_idle: ATTACK_RIGHT_IDLE;
			case attack_right_raised: ATTACK_RIGHT_RAISED;
			case attack_right_attack: ATTACK_RIGHT_ATTACK;
			case attack_left_idle: ATTACK_LEFT_IDLE;
			case attack_left_raised: ATTACK_LEFT_RAISED;
			case attack_left_attack: ATTACK_LEFT_ATTACK;
		}

		Assert.notNull( key, "failed to recognize animation: " + animation );

		return key;
	}

	#if !debug inline #end
	public static function fromString( animation : String ) : AnimationKey {
		return fromCdb( cast animation );
	}
}
