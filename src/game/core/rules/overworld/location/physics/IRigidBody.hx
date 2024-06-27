package game.core.rules.overworld.location.physics;

typedef ThreeDeeVectorType = {
	var x : Float;
	var y : Float;
	var z : Float;
}

enum RigidBodyType {
	DYNAMIC;
	STATIC;
	KINEMATIC;
}

interface IRigidBody {

	function addShape( shape : IRigidBodyShape ) : Void;
	function setRotationFactor( vec : ThreeDeeVectorType ) : Void;
	function setLinearDamping( vec : ThreeDeeVectorType ) : Void;
	function setGravityScale( value : Float ) : Void;
}
