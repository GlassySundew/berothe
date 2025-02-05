package game.domain.overworld.location.physics;

import game.physics.oimo.RayCastCallback;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import oimo.dynamics.rigidbody.Shape;

interface IPhysicsEngine {

	function update( dt : Float ) : Void;
	function addRigidBody( rigidBody : IRigidBody ) : Void;
	function removeRigidBody( rigidBody : IRigidBody ) : Void;
	function setDebugDraw( debugDraw : IDebugDraw ) : Void;
	function getDebugDraw() : IDebugDraw;
	function drawDebug() : Void;
	function dispose() : Void;
	function rayCast(
		start : ThreeDeeVector,
		end : ThreeDeeVector,
		rayCastCallBack : RayCastCallback
	) : Void;

	function convexCast(
		convex : IGeometry,
		start : ITransform,
		translation : ThreeDeeVector,
		callback : RayCastCallback
	) : Void;
}
