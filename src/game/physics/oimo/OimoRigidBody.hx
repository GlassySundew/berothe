package game.physics.oimo;

import core.MutableProperty;
import h3d.Quat;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import util.Assert;
import game.core.rules.overworld.location.physics.IRigidBody;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import game.core.rules.overworld.location.physics.Types.RigidBodyType;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;

class OimoRigidBody implements IRigidBody {

	public final transformProvider : OimoRigidBodyTransformProvider;

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

	public final shapes : Array<IRigidBodyShape> = [];
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

	public inline function new( rigidBody : RigidBody ) {
		this.rigidBody = rigidBody;
		this.transformProvider = new OimoRigidBodyTransformProvider( rigidBody );

		x.addOnValue( ( value ) -> rigidBody._transform._positionX = value );
		y.addOnValue( ( value ) -> rigidBody._transform._positionY = value );
		z.addOnValue( ( value ) -> rigidBody._transform._positionZ = value );

		velX.addOnValue( ( value ) -> rigidBody._velX = value );
		velY.addOnValue( ( value ) -> rigidBody._velY = value );
		velZ.addOnValue( ( value ) -> rigidBody._velZ = value );

		rigidBody._sleeping.subscribeProp( isSleeping );
		rigidBody.onUpdated.add( onUpdated );
	}

	public inline function addShape( shape : IRigidBodyShape ) {
		shapes.push( shape );
		rigidBody.addShape( Std.downcast( shape, OimoRigidBodyShape ).shape );
	}

	public inline function setRotationFactor( rotationFactor : ThreeDeeVector ) {
		rigidBody.setRotationFactor( rotationFactor.toOimo() );
	}

	public inline function setLinearDamping( damping : ThreeDeeVector ) {
		rigidBody.setLinearDamping( damping.toOimo() );
	}

	public inline function setGravityScale( gravitiScale : Float ) {
		rigidBody.setGravityScale( gravitiScale );
	}

	public inline function setPosition( pos : ThreeDeeVector ) {
		rigidBody.setPosition( pos.toOimo() );
		onUpdated();
	}

	public inline function wakeUp() {
		rigidBody.wakeUp();
		// onUpdated();
	}

	public inline function move( x : Float, y : Float, z : Float ) {
		rigidBody.translate( new Vec3( x, y, z ) );
		onUpdated(); // ! NO IDEA WHY BUT DO NOT UNCOMMENT THIS LINE, OR REPLICATION WILL BREAK
	}

	public inline function setRotation( x : Float, y : Float, z : Float ) {
		rigidBody.setRotationXyz( new Vec3( x, y, z ) );
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
		var vector = ThreeDeeVector.anglesFromQuat( rigidBody._transform.getOrientation() );
		rotationX.val = vector.x;
		rotationY.val = vector.y;
		rotationZ.val = vector.z;
	}

	public function getShape() : Null<IRigidBodyShape> {
		return shapes[0];
	}
}
