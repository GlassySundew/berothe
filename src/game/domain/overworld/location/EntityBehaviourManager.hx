package game.domain.overworld.location;

import haxe.rtti.Rtti;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;

typedef EntityBehaviourData = {
	behaviour : EntityBehaviourBase,
	accumulatedDt : Float,
	accumulatedTmod : Float,
}

class EntityBehaviourManager {

	static final BEHAVIOUR_UPDATES_PER_FRAME : Int = 1;

	var scrollIndex = 0;
	final behaviours : Array<EntityBehaviourData> = [];

	public function new() {}

	public function attachBehaviour( behaviour : EntityBehaviourBase, entity : OverworldEntity ) {
		var behaviourData = {
			behaviour : behaviour,
			accumulatedDt : 0.,
			accumulatedTmod : 0.
		};
		behaviours.push( behaviourData );
		entity.disposed.then( ( _ ) -> behaviours.remove( behaviourData ) );
	}

	#if !debug inline #end
	public function update( dt : Float, tmod : Float ) {
		for ( data in behaviours ) {
			data.accumulatedDt += dt;
			data.accumulatedTmod += tmod;
		}

		var behavioursUpdatedThisCycle = 0;
		for ( i in 0...BEHAVIOUR_UPDATES_PER_FRAME ) {
			if ( behavioursUpdatedThisCycle >= behaviours.length ) {
				break;
			}

			scrollIndex %= behaviours.length;
			var data = behaviours[scrollIndex++];
			data.behaviour.update( data.accumulatedDt, data.accumulatedTmod );
			data.accumulatedDt = 0;
			data.accumulatedTmod = 0;
			behavioursUpdatedThisCycle++;
		}
	}
}
