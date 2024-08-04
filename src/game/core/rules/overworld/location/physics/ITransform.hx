package game.core.rules.overworld.location.physics;

import game.core.rules.overworld.location.physics.Types.Quat;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;

interface ITransform {

	function getPosition() : ThreeDeeVector;
	function setPosition( vec : ThreeDeeVector ) : Void;
	function getRotation() : ThreeDeeVector;
	function setRotation( vec : ThreeDeeVector ) : Void;

	function clone() : ITransform;
	function copyFrom( transform : ITransform ) : ITransform;
	function translate( translation : ThreeDeeVector ) : Void;
}
