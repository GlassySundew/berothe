package game.domain.overworld.location.physics;

import game.physics.oimo.ContactCallbackWrapper;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

interface IRigidBodyShape {

	function moveLocally( x : Float, y : Float, z : Float ) : Void;
	function setLocalRotation( x : Float, y : Float, z : Float ) : Void;
	function setCollisionGroup( collisionGroup : Int ) : Void;
	function setCollisionMask( collisionMask : Int ) : Void;
	function getCollisionGroup() : Int;
	function getCollisionMask() : Int;
	function getPosition() : ThreeDeeVector;
	function setContactCallbackWrapper( callback : ContactCallbackWrapper ) : Void;
	function getContactCallbackWrapper() : ContactCallbackWrapper;
	function setDensity( value : Float ) : Void;
	function setRestitution( value : Float ) : Void;
	function setFriction( value : Float ) : Void;
	function setVolume( value : Float ) : Void;
	function getConfig() : IShapeConfig;
}
