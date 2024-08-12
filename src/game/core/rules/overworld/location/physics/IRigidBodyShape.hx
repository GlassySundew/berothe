package game.core.rules.overworld.location.physics;

import en.collide.ContactCallbackWrapper;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;

interface IRigidBodyShape {

	function moveLocally( x : Float, y : Float, z : Float ) : Void;
	function setCollisionGroup( collisionGroup : Int ) : Void;
	function setCollisionMask( collisionMask : Int ) : Void;
	function getCollisionGroup() : Int;
	function getCollisionMask() : Int;
	function getPosition() : ThreeDeeVector;
	function setContactCallback( callback : ContactCallbackWrapper ) : Void;
	function getContactCallback() : ContactCallbackWrapper;
}
