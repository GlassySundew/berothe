package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.anim.AnimationState;
import dn.MacroTools;

class EntityAnimations {

	/**
		values are identifiers from entity composer animation
	**/
	public final byKey : Map<AnimationKey, EntityAnimationState> = [];

	public function new( animations : cdb.Types.ArrayRead<Data.EntityView_animations> ) {
		for ( animation in animations ) {
			var key : AnimationKey = AnimationKey.fromCdb( animation.key );

			Assert.isNull( byKey[key], 'unsupported behaviour: by key ($key) animation node doubled' );

			byKey[key] = new EntityAnimationState(
				animation.speedMult,
				[for ( anim in animation.animations ) anim.key]
			);
		}
	}
}

class EntityAnimationState {

	public final speedMult : Float;
	public final keys : Array<AnimationKey>;

	public inline function new(
		speedMult : Float,
		keys : Array<String>
	) {
		this.speedMult = speedMult;
		this.keys = keys;
	}
}
