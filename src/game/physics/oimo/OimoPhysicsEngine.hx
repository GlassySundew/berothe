package game.physics.oimo;

import oimo.common.Vec3;
import game.debug.HeapsOimophysicsDebugDraw;
import oimo.dynamics.common.DebugDraw;
import game.core.rules.overworld.location.physics.IDebugDraw;
import game.physics.oimo.OimoRigidBody;
import util.Assert;
import game.core.rules.overworld.location.physics.IRigidBody;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import oimo.dynamics.World;

class OimoPhysicsEngine implements IPhysicsEngine {

	var world : World = new World();
	var debugDraw : HeapsOimophysicsDebugDraw;

	public inline function new() {
		world.setGravity( new Vec3( 0, 0, -9.8 ) );
	}

	public function update( dt : Float ) {
		world.step( dt );

		if ( debugDraw != null && debugDraw.graphics.visible ) {
			Std.downcast( debugDraw, HeapsOimophysicsDebugDraw ).graphics.clear();
			inline world.debugDraw();
		}
	}

	public function addRigidBody( rigidBody : IRigidBody ) {
		Assert.isOfType( rigidBody, OimoRigidBody );
		world.addRigidBody( Std.downcast( rigidBody, OimoRigidBody ).rigidBody );
	}

	public function setDebugDraw( debugDraw : IDebugDraw ) {
		Assert.isNull( this.debugDraw );
		Assert.isOfType( debugDraw, DebugDraw );
		this.debugDraw = Std.downcast( debugDraw, HeapsOimophysicsDebugDraw );

		world.setDebugDraw( this.debugDraw );
	}
}
