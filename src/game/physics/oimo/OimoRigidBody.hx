package game.physics.oimo;

import core.MutableProperty;
import oimo.common.Vec3;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.Types.RigidBodyType;
import util.Assert;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.Shape;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.IRigidBody;

class OimoRigidBody implements IRigidBody {

	public static function create( shape : IRigidBodyShape, type : RigidBodyType ) : IRigidBody {
		Assert.isOfType( shape, OimoRigidBodyShape );
		var unwrapShape = Std.downcast( shape, OimoRigidBodyShape ).shape;

		var config = new RigidBodyConfig();
		config.type = switch type {
			case DYNAMIC: oimo.dynamics.rigidbody.RigidBodyType.DYNAMIC;
			case STATIC: oimo.dynamics.rigidbody.RigidBodyType.STATIC;
			case KINEMATIC: oimo.dynamics.rigidbody.RigidBodyType.KINEMATIC;
		}

		var rigidBody = new RigidBody( config );
		rigidBody.addShape( unwrapShape );

		return new OimoRigidBody( rigidBody );
	}

	public final rigidBody : RigidBody;
	public final x : MutableProperty<Float> = new MutableProperty();
	public final y : MutableProperty<Float> = new MutableProperty();
	public final z : MutableProperty<Float> = new MutableProperty();
	public final velX : MutableProperty<Float> = new MutableProperty();
	public final velY : MutableProperty<Float> = new MutableProperty();
	public final velZ : MutableProperty<Float> = new MutableProperty();
	public final rotationX : MutableProperty<Float> = new MutableProperty();
	public final rotationY : MutableProperty<Float> = new MutableProperty();
	public final rotationZ : MutableProperty<Float> = new MutableProperty();

	public var isSleeping( default, null ) : MutableProperty<Bool> = new MutableProperty( false );

	var initialShape : Shape;

	public inline function new( rigidBody : RigidBody ) {
		this.rigidBody = rigidBody;

		x.addOnValue( ( value ) -> rigidBody._transform._positionX = value );
		y.addOnValue( ( value ) -> rigidBody._transform._positionY = value );
		z.addOnValue( ( value ) -> rigidBody._transform._positionZ = value );

		velX.addOnValue( ( value ) -> rigidBody._velX = value );
		velY.addOnValue( ( value ) -> rigidBody._velY = value );
		velZ.addOnValue( ( value ) -> rigidBody._velZ = value );

		rigidBody._sleeping.subscribeProp( isSleeping );
	}

	public inline function addShape( shape : IRigidBodyShape ) {
		rigidBody.addShape( Std.downcast( shape, OimoRigidBodyShape ).shape );
		onUpdated();
	}

	public inline function setRotationFactor( rotationFactor : ThreeDeeVector ) {
		rigidBody.setRotationFactor(
			new Vec3(
				rotationFactor.x,
				rotationFactor.y,
				rotationFactor.z
			) );
	}

	public inline function setLinearDamping( damping : ThreeDeeVector ) {
		rigidBody.setLinearDamping(
			new Vec3(
				damping.x,
				damping.y,
				damping.z
			)
		);
	}

	public inline function setGravityScale( gravitiScale : Float ) {
		rigidBody.setGravityScale( gravitiScale );
	}

	public inline function setPosition( pos : ThreeDeeVector ) {
		rigidBody.setPosition( new Vec3( pos.x, pos.y, pos.z ) );
		onUpdated();
	}

	public inline function wakeUp() {
		rigidBody.wakeUp();
		onUpdated();
	}

	public inline function move( x : Float, y : Float, z : Float ) {
		rigidBody.translate( new Vec3( x, y, z ) );
		// onUpdated(); //! NO IDEA WHY BUT DO NOT UNCOMMENT THIS LINE, OR REPLICATION WILL BREAK
	}

	public inline function setRotation( x : Float, y : Float, z : Float ) {
		rigidBody.setRotationXyz( new Vec3( x, y, z ) );
		onUpdated();
	}

	public inline function sleep() {
		rigidBody.sleep();
	}

	public inline function setAutoSleep( value : Bool ) {
		rigidBody._autoSleep = value;
	}

	function onUpdated() {
		x.val = rigidBody._transform._positionX;
		y.val = rigidBody._transform._positionY;
		z.val = rigidBody._transform._positionZ;
		velX.val = rigidBody._velX;
		velY.val = rigidBody._velY;
		velZ.val = rigidBody._velZ;
		var rotation = rigidBody._transform.getOrientation();
		rotationX.val = rotation.x;
		rotationY.val = rotation.y;
		rotationZ.val = rotation.z;
	}
}
