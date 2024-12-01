package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.Quat;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

interface ITransform {

	function getPosition() : ThreeDeeVector;
	function setPosition( vec : ThreeDeeVector ) : Void;
	function getRotation() : ThreeDeeVector;
	function setRotation( vec : ThreeDeeVector ) : Void;
	function add( vec : ThreeDeeVector ) : Void;

	function clone() : ITransform;
	function copyFrom( transform : ITransform ) : ITransform;
	function translate( translation : ThreeDeeVector ) : Void;
}
