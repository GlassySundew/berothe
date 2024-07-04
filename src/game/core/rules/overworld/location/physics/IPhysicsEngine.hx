package game.core.rules.overworld.location.physics;

import en.collide.RayCastCallback;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import oimo.dynamics.rigidbody.Shape;

interface IPhysicsEngine {

	public function update( dt : Float ) : Void;
	public function addRigidBody( rigidBody : IRigidBody ) : Void;
	public function setDebugDraw( debugDraw : IDebugDraw ) : Void;
	public function rayCast(
		start : ThreeDeeVector,
		end : ThreeDeeVector,
		rayCastCallBack : RayCastCallback
	) : Void;

	public function getShapeByOimo( shape : Shape ) : IRigidBodyShape;
}
