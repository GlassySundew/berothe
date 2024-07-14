package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.anim.AnimationState;
import dn.MacroTools;

class EntityAnimations {

	/**
		values are identifiers from entity composer animation
	**/
	public final byKey : Map<AnimationKey, Array<String>> = [];

	public function new( animations : cdb.Types.ArrayRead<Data.EntityView_animations> ) {

		for ( animation in animations ) {
			var key : AnimationKey = switch animation.key {
				case idle: IDLE;
				case walk: WALK;
				case attack_prime_idle: ATTACK_PRIME_IDLE;
				case attack_prime_attack: ATTACK_PRIME_ATTACK;
				case attack_seco_idle: ATTACK_SECO_IDLE;
				case attack_seco_attack: ATTACK_SECO_ATTACK;
			}

			Assert.isNull( byKey[key], 'unsupported behaviour: by key ($key) animation node doubled' );

			byKey[key] = [for ( anim in animation.animations ) anim.key];
		}
	}
}
