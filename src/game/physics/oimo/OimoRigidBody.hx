package game.physics.oimo;

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
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

class OimoRigidBody implements IRigidBody {

	public final transform : ITransform;

	public static function create(
		shape : IRigidBodyShape,
		type : RigidBodyType,
		?props : Any
	) : IRigidBody {
		
		Assert.isOfType( shape, OimoRigidBodyShape );
		var unwrapShape = Std.downcast( shape, OimoRigidBodyShape ).shape;

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
				wakeUp();
			}
		);
		y.addOnValue(
			( oldVal, value ) -> {
				rigidBody._transform._positionY = value;
				wakeUp();
			}
		);
		z.addOnValue(
			( oldVal, value ) -> {
				rigidBody._transform._positionZ = value;
				wakeUp();
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
			} );
		velY.addOnValue(
			( oldVal, value ) -> {
				rigidBody._velY = value;
				wakeUp();
			} );
		velZ.addOnValue(
			( oldVal, value ) -> {
				rigidBody._velZ = value;
				wakeUp();
			} );

		rigidBody._sleeping.subscribeProp( isSleeping );
		isSleeping.addOnValue( ( _, _ ) -> onUpdated() );
		onUpdated();
		rigidBody.onUpdated.add( onUpdated.bind( true ) );
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

	function onUpdated( ?doRoundSleep = true ) {
		if ( rotationInvalidate ) {
			rigidBody.setRotationXyz(
				new Vec3(
					rotationX.val,
					rotationY.val,
					rotationZ.val
				)
			);
		}

		x.val = rigidBody._transform._positionX;
		y.val = rigidBody._transform._positionY;
		z.val = rigidBody._transform._positionZ;
		velX.val = rigidBody._velX;
		velY.val = rigidBody._velY;
		velZ.val = rigidBody._velZ;
		var vector = rigidBody._transform.getOrientation().toMat3().toEulerXyz();
		rotationX.val = vector.x;
		rotationY.val = vector.y;
		rotationZ.val = vector.z;

		var tmod =
			#if server
			game.net.server.GameServer.inst.tmod;
			#elseif client
			game.net.client.GameClient.inst.tmod;
			#end

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
		return shapes[0];
	}
}
