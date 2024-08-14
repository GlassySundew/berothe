package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;

interface IDebugDraw {

	function setVisibility( value : Bool ) : Void;
	function point( v : ThreeDeeVector, color : ThreeDeeVector ) : Void;
	function triangle(
		v1 : ThreeDeeVector,
		v2 : ThreeDeeVector,
		v3 : ThreeDeeVector,
		n1 : ThreeDeeVector,
		n2 : ThreeDeeVector,
		n3 : ThreeDeeVector,
		color : ThreeDeeVector
	) : Void;
	function line(
		v1 : ThreeDeeVector,
		v2 : ThreeDeeVector,
		color : ThreeDeeVector
	) : Void;
}
