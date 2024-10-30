package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.anim.AnimationState;
import dn.MacroTools;

class EntityAnimations {

	/**
		values are identifiers from entity composer animation
	**/
	public final byKey : Map<AnimationKey, EntityAnimationState> = [];

	public function new( animations : Null<cdb.Types.ArrayRead<Data.EntityView_animations>> ) {
		if ( animations != null ) {
			for ( animation in animations ) {
				var key : AnimationKey = AnimationKey.fromCdb( animation.key );

				Assert.isNull( byKey[key], 'unsupported behaviour: by key ($key) animation node doubled' );

				byKey[key] = new EntityAnimationState(
					animation.speedMult,
					animation.isAffectedByStats,
					[for ( anim in animation.animations ) anim.key]
				);
			}
		}
	}
}

class EntityAnimationState {

	public final speedMult : Float;
	public final isAffectedByStats : Bool;
	public final keys : Array<AnimationKey>;

	public inline function new(
		speedMult : Float,
		isAffectedByStats : Bool,
		keys : Array<String>
	) {
		this.speedMult = speedMult;
		this.isAffectedByStats = isAffectedByStats;
		this.keys = keys;
	}
}
