package game.core.rules.overworld.location.physics;

import game.core.rules.overworld.location.physics.Types.ThreeDeeVectorType;

interface IRigidBody {

	function addShape( shape : IRigidBodyShape ) : Void;
	function setRotationFactor( vec : ThreeDeeVectorType ) : Void;
	function setLinearDamping( vec : ThreeDeeVectorType ) : Void;
	function setGravityScale( value : Float ) : Void;
	function setPosition( pos : ThreeDeeVectorType ) : Void;
}
