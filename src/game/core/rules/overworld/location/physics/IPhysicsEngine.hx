package game.core.rules.overworld.location.physics;



interface IPhysicsEngine {

	public function update( dt : Float ) : Void;
	public function addRigidBody( rigidBody : IRigidBody ) : Void;
}
