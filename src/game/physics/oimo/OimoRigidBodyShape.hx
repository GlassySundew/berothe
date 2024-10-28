package game.physics.oimo;

import oimo.common.Vec3;
import util.Assert;
import game.physics.oimo.ContactCallbackWrapper;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.IShapeConfig;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.physics.oimo.OimoWrappedShape;

class OimoRigidBodyShape implements IRigidBodyShape {

	public static function create( config : IShapeConfig ) : IRigidBodyShape {
		var shape = //
			new OimoRigidBodyShape(
				new OimoWrappedShape(
					config
				)
			);

		return shape;
	}

	public final shape : OimoWrappedShape;

	public inline function new( shape : OimoWrappedShape ) {
		this.shape = shape;
		OimoShapeCache.provideShape( this );
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

	public inline function setLocalRotation( x : Float, y : Float, z : Float ) {
		shape._localTransform.setRotationXyz( new Vec3( x, y, z ) );
	}

	public function getPosition() : ThreeDeeVector {
		var transform = shape.getTransform();
		return {
			x : transform._positionX,
			y : transform._positionY,
			z : transform._positionZ
		};
	}

	public inline function getCollisionGroup() : Int {
		return shape._collisionGroup;
	}

	public inline function getCollisionMask() : Int {
		return shape._collisionMask;
	}

	public inline function setContactCallback( callback : ContactCallbackWrapper ) {
		shape.setContactCallback( callback );
	}

	public inline function getContactCallback() : ContactCallbackWrapper {
		#if debug Assert.isOfType( shape.getContactCallback(), ContactCallbackWrapper ); #end
		return Std.downcast( shape.getContactCallback(), ContactCallbackWrapper );
	}
}
