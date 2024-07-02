package game.core.rules.overworld.location.physics;

import game.core.rules.overworld.location.physics.Types.ThreeDeeVectorType;

interface IDebugDraw {

	function setVisibility( value : Bool ) : Void;
	function point( v : ThreeDeeVectorType, color : ThreeDeeVectorType ) : Void;
	function triangle(
		v1 : ThreeDeeVectorType,
		v2 : ThreeDeeVectorType,
		v3 : ThreeDeeVectorType,
		n1 : ThreeDeeVectorType,
		n2 : ThreeDeeVectorType,
		n3 : ThreeDeeVectorType,
		color : ThreeDeeVectorType
	) : Void;
	function line(
		v1 : ThreeDeeVectorType,
		v2 : ThreeDeeVectorType,
		color : ThreeDeeVectorType
	) : Void;
}
