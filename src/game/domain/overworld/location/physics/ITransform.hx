package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.Quat;
import game.domain.overworld.location.physics.Types.Vec;

interface ITransform {

	function getPosition() : Vec;
	function setPosition( vec : Vec ) : Void;
	function getRotation() : Vec;
	function setRotation( vec : Vec ) : Void;
	function add( vec : Vec ) : Void;

	function clone() : ITransform;
	function copyFrom( transform : ITransform ) : ITransform;
	function translate( translation : Vec ) : Void;
}
