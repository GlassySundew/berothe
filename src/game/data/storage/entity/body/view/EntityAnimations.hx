package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.anim.AnimationState;
import dn.MacroTools;

class EntityAnimations {

	/**
		values are identifiers from entity composer animation
	**/
	public final byKey : Map<AnimationKey, Array<AnimationKey>> = [];

	public function new( animations : cdb.Types.ArrayRead<Data.EntityView_animations> ) {
		for ( animation in animations ) {
			var key : AnimationKey = AnimationKey.fromCdb( animation.key );

			Assert.isNull( byKey[key], 'unsupported behaviour: by key ($key) animation node doubled' );

			byKey[key] = [for ( anim in animation.animations ) anim.key];
		}
	}
}
