package game.domain.overworld.location.physics;

import game.physics.oimo.ContactCallbackWrapper;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

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
