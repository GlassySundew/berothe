package game.physics;

import game.core.rules.overworld.location.IPhysicsEngine;
import oimo.dynamics.World;

class OimoPhysicsEngine implements IPhysicsEngine {

	var world = new World();

	public inline function new() {}

	public function update( dt : Float ) {
		world.step( dt );
	}
}
