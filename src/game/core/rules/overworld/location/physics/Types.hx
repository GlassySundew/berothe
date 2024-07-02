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
