package game.physics.oimo;

import hxd.Timer;
import oimo.dynamics.rigidbody.MassData;
import oimo.common.Mat3;
import dn.M;
import game.domain.overworld.location.physics.ITransform;
import core.MutableProperty;
import h3d.Quat;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import util.Assert;
import game.domain.overworld.location.physics.IRigidBody;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.Types.RigidBodyType;
import game.domain.overworld.location.physics.Types.Vec;

class OimoRigidBody implements IRigidBody {

	public final transform : ITransform;

	public static function create(
		shape : IRigidBodyShape,
		type : RigidBodyType,
		?props : Any
	) : IRigidBody {

		Assert.isOfType( shape, OimoWrappedShape );
		var unwrapShape = Std.downcast( shape, OimoWrappedShape );

		var config = new RigidBodyConfig();
		config.type = switch type {
			case DYNAMIC: oimo.dynamics.rigidbody.RigidBodyType.DYNAMIC;
			case STATIC: oimo.dynamics.rigidbody.RigidBodyType.STATIC;
			case KINEMATIC: oimo.dynamics.rigidbody.RigidBodyType.KINEMATIC;
			case TRIGGER: oimo.dynamics.rigidbody.RigidBodyType.TRIGGER;
		}

		var rigidBody = new RigidBody( config );
		rigidBody.addShape( unwrapShape );
		rigidBody.userData = props;

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

	var rotationInvalidate = true;

	public inline function new( rigidBody : RigidBody ) {
		this.rigidBody = rigidBody;
		this.transform = new OimoTransform( rigidBody._transform );

		x.addOnValue(
			( oldVal, value ) -> {
				rigidBody._transform._positionX = value;
				updateTransform();
			}
		);
		y.addOnValue(
			( oldVal, value ) -> {
				rigidBody._transform._positionY = value;
				updateTransform();
			}
		);
		z.addOnValue(
			( oldVal, value ) -> {
				rigidBody._transform._positionZ = value;
				updateTransform();
			}
		);

		function wakeByRotation( _, _ ) {
			rotationInvalidate = true;
			wakeUp();
			onUpdated( false );
		}

		rotationX.addOnValue( wakeByRotation );
		rotationY.addOnValue( wakeByRotation );
		rotationZ.addOnValue( wakeByRotation );

		velX.addOnValue(
			( oldVal, value ) -> {
				rigidBody._velX = value;
				wakeUp();
				updateTransform();
			} );
		velY.addOnValue(
			( oldVal, value ) -> {
				rigidBody._velY = value;
				wakeUp();
				updateTransform();
			} );
		velZ.addOnValue(
			( oldVal, value ) -> {
				rigidBody._velZ = value;
				wakeUp();
				updateTransform();
			} );

		rigidBody._sleeping.subscribeProp( isSleeping );
		isSleeping.addOnValue( ( _, _ ) -> onUpdated() );
		onUpdated();
		rigidBody.onUpdated.add( onUpdated.bind( true ) );
	}

	public inline function addShape( shape : IRigidBodyShape ) {
		shapes.push( shape );
		rigidBody.addShape( Std.downcast( shape, OimoWrappedShape ) );
	}

	public inline function setRotationFactor( rotationFactor : Vec ) {
		rigidBody.setRotationFactor( rotationFactor.toOimo() );
	}

	public inline function setLinearDamping( damping : Vec ) {
		rigidBody.setLinearDamping( damping.toOimo() );
	}

	public inline function setGravityScale( gravitiScale : Float ) {
		rigidBody.setGravityScale( gravitiScale );
	}

	public inline function setPosition( pos : Vec ) {
		rigidBody.setPosition( pos.toOimo() );
	}

	public inline function setType( type : RigidBodyType ) {
		rigidBody.setType( switch type {
			case DYNAMIC: oimo.dynamics.rigidbody.RigidBodyType._DYNAMIC;
			case KINEMATIC: oimo.dynamics.rigidbody.RigidBodyType._KINEMATIC;
			case STATIC: oimo.dynamics.rigidbody.RigidBodyType._STATIC;
			case TRIGGER: oimo.dynamics.rigidbody.RigidBodyType._TRIGGER;
		} );
	}

	public inline function updateTransform() {
		@:privateAccess
		rigidBody.updateTransformExt();
	}

	public inline function wakeUp() {
		rigidBody.wakeUp();
	}

	public inline function move( x : Float, y : Float, z : Float ) {
		rigidBody.translate( new Vec3( x, y, z ) );
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

	public inline function setMassData( massData : MassData ) : Void {
		rigidBody.setMassData( massData );
	}

	public function onUpdated( ?doRoundSleep = true ) {
		if ( rotationInvalidate ) {
			var quat = new Quat();
			quat.initRotation(
				rotationX.val,
				rotationY.val,
				rotationZ.val
			);
			var quatMat = quat.toMatrix();
			rigidBody.setRotation(
				new Mat3().fromQuat( new oimo.common.Quat( quat.x, quat.y, quat.z, quat.w ) )
			);
			updateTransform();
		}

		x.val = rigidBody._transform._positionX;
		y.val = rigidBody._transform._positionY;
		z.val = rigidBody._transform._positionZ;
		velX.val = rigidBody._velX;
		velY.val = rigidBody._velY;
		velZ.val = rigidBody._velZ;

		var oimoQuat = rigidBody._transform.getRotation().toQuat();
		var hpsRotation = new Quat(
			oimoQuat.x,
			oimoQuat.y,
			oimoQuat.z,
			oimoQuat.w
		)
			.toMatrix()
			.getEulerAngles();
		rotationX.val = hpsRotation.x;
		rotationY.val = hpsRotation.y;
		rotationZ.val = hpsRotation.z;

		var tmod = Timer.tmod;

		if (
			doRoundSleep
			&& M.fabs( velX.val ) < 0.005 * tmod
			&& M.fabs( velY.val ) < 0.005 * tmod
			&& M.fabs( velZ.val ) < 0.005 * tmod
		) {
			rigidBody.sleep();
		}

		rotationInvalidate = false;
	}

	public function getShape() : Null<IRigidBodyShape> {
		return Std.downcast( rigidBody._shapeList, OimoWrappedShape );
	}
}
