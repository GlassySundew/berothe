package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;

class EntityBehaviourManager {

	final behaviours : Array<EntityBehaviourBase> = [];
	final behaviourUpdatesPerFrame : Int = 5;

	var scrollIndex = 0;

	public function new() {}

	public function attachBehaviour( behaviour : EntityBehaviourBase, entity : OverworldEntity ) {
		behaviours.push( behaviour );
		entity.disposed.then( ( _ ) -> behaviours.remove( behaviour ) );
	}

	public function update( dt : Float, tmod : Float ) {
		for ( i in 0...behaviourUpdatesPerFrame ) {

			if ( scrollIndex >= behaviours.length ) {
				scrollIndex = 0;
				if ( behaviourUpdatesPerFrame >= behaviours.length ) return;
			}
			behaviours[scrollIndex++].update( dt, tmod );
		}
	}
}
