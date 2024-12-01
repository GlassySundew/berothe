package game.domain.overworld.location;

import haxe.rtti.Rtti;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;

class EntityBehaviourManager {

	static final behaviours : Array<EntityBehaviourBase> = [];
	static final BEHAVIOUR_UPDATES_PER_FRAME : Int = 120;

	var scrollIndex = 0;

	public function new() {}

	public function attachBehaviour( behaviour : EntityBehaviourBase, entity : OverworldEntity ) {
		behaviours.push( behaviour );
		entity.disposed.then( ( _ ) -> behaviours.remove( behaviour ) );
	}

	public function update( dt : Float, tmod : Float ) {
		var behavioursUpdatedThisCycle = 0;
		for ( i in 0...BEHAVIOUR_UPDATES_PER_FRAME ) {
			if ( behavioursUpdatedThisCycle >= behaviours.length ) {
				return;
			}

			scrollIndex %= behaviours.length;
			behaviours[scrollIndex++].update( dt, tmod );
			behavioursUpdatedThisCycle++;
		}
	}
}
