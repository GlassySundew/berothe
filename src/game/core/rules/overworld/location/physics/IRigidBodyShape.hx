package game.core.rules.overworld.location.physics;

interface IRigidBodyShape {

	function move( x : Float, y : Float, z : Float ) : Void;
	function setCollisionGroup( collisionGroup : Int ) : Void;
	function setCollisionMask( collisionMask : Int ) : Void;
}
