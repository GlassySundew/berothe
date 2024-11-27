package game.domain.overworld.entity.component.ai.behaviours;

import dn.M;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.domain.overworld.location.Location;

enum PollingState {
	FLYING_TO;
	IDLE;
	POLLING;
}

class FlowerPollinator extends EntityBehaviourBase {

	final POLLING_RANGE = 1;

	var flowerChosen : ThreeDeeVector;
	var pollingState : PollingState;

	override function updateBehaviour( dt : Float, tmod : Float ) {
		switch pollingState {
			case IDLE | null:
				pollingState = FLYING_TO;
				var location = entity.location.getValue();
				flowerChosen = location.localPoints.getRandomPointByName( FLOWER );
			case FLYING_TO:
				if ( //
					M.dist(
						entity.transform.x.val,
						entity.transform.y.val,
						flowerChosen.x,
						flowerChosen.y
					) < POLLING_RANGE //
				) {
					pollingState = POLLING;
				} else {
					walkTo( flowerChosen.x, flowerChosen.y, tmod );
				}
			case POLLING:
		}
	}
}
