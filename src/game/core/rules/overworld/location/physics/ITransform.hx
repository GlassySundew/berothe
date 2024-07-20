package game.core.rules.overworld.location.physics;

import game.core.rules.overworld.location.physics.Types.Quat;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;

interface ITransform {

	function getPosition() : ThreeDeeVector;
	function setPosition( vec : ThreeDeeVector ) : Void;
	function getRotation() : Quat;
	function setRotation( vec : ThreeDeeVector ) : Void;
}
