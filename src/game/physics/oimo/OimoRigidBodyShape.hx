package game.physics.oimo;

import oimo.dynamics.rigidbody.ShapeConfig;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;

class OimoRigidBodyShape implements IRigidBodyShape {

	public final shape : Shape;

	public inline function new( config : ShapeConfig ) {
		shape = new Shape( config );
	}

	public inline function setCollisionGroup( collisionGroup : Int ) {
		shape.setCollisionGroup( collisionGroup );
	}

	public inline function setCollisionMask( collisionMask : Int ) {
		shape.setCollisionMask( collisionMask );
	}

	public function move(x:Float, y:Float, z:Float) {
		shape._localTransform._positionX += x;
		shape._localTransform._positionY += y;
		shape._localTransform._positionZ += z;
	}
}
