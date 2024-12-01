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

	static final POLLING_RANGE = 1;
	static final POLLING_DURATION_MIN = 10;
	static final POLLING_DURATION_MAX = 20;

	var flowerChosen : ThreeDeeVector;
	var pollingState : PollingState;
	var flyComp : EntityFlyComponent;
	var isPollingTimerSet : Bool = false;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.components.onAppear(
			EntityFlyComponent,
			( cl, flyComp ) -> this.flyComp = flyComp
		);
	}

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
					objectivePoint.set( flowerChosen.x, flowerChosen.y, flowerChosen.z );
					smartWalkToObjective( tmod );
					dynamics.isMovementApplied.val = true;
				}
			case POLLING:
				flyComp?.suspend();
				dynamics.isMovementApplied.val = false;
				if ( !isPollingTimerSet ) {
					isPollingTimerSet = true;
					entity.delayer.addS(
						() -> {
							pollingState = IDLE;
							isPollingTimerSet = false;
							flyComp?.resume();
						},
						Random.int( POLLING_DURATION_MIN, POLLING_DURATION_MAX )
					);
				}
		}
	}
}
