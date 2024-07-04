package game.physics.oimo;

import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import oimo.dynamics.rigidbody.ShapeConfig;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;

class OimoRigidBodyShape implements IRigidBodyShape {

	public static function create( config : ShapeConfig ) : IRigidBodyShape {
		return new OimoRigidBodyShape( new Shape( config ) );
	}

	public final shape : Shape;

	public inline function new( shape : Shape ) {
		this.shape = shape;
	}

	public inline function setCollisionGroup( collisionGroup : Int ) {
		shape.setCollisionGroup( collisionGroup );
	}

	public inline function setCollisionMask( collisionMask : Int ) {
		shape.setCollisionMask( collisionMask );
	}

	public inline function moveLocally( x : Float, y : Float, z : Float ) {
		shape._localTransform._positionX += x;
		shape._localTransform._positionY += y;
		shape._localTransform._positionZ += z;
	}

	public function getPosition() : ThreeDeeVector {
		var transform = shape.getTransform();
		return {
			{
				x : transform._positionX,
				y : transform._positionY,
				z : transform._positionZ
			}
		};
	}

	public inline function getCollisionGroup() : Int {
		return shape._collisionGroup;
	}

	public inline function getCollisionMask() : Int {
		return shape._collisionMask;
	}
}
