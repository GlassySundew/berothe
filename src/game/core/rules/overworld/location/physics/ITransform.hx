package game.core.rules.overworld.location.physics;

import game.core.rules.overworld.location.physics.Types.Quat;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;

interface ITransform {

	function getPosition() : ThreeDeeVector;
	function getRotation() : Quat;
}
