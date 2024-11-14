package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.RigidBodyType;
import core.IMutableProperty;
import core.IProperty;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

interface IRigidBody {

	final x : IMutableProperty<Float>;
	final y : IMutableProperty<Float>;
	final z : IMutableProperty<Float>;

	final velX : IMutableProperty<Float>;
	final velY : IMutableProperty<Float>;
	final velZ : IMutableProperty<Float>;

	final rotationX : IMutableProperty<Float>;
	final rotationY : IMutableProperty<Float>;
	final rotationZ : IMutableProperty<Float>;

	final transform : ITransform;

	var isSleeping( default, null ) : IProperty<Bool>;

	function move( x : Float, y : Float, z : Float ) : Void;
	function setRotation( x : Float, y : Float, z : Float ) : Void;
	function addShape( shape : IRigidBodyShape ) : Void;
	function getShape() : Null<IRigidBodyShape>;
	function setRotationFactor( vec : ThreeDeeVector ) : Void;
	function setLinearDamping( vec : ThreeDeeVector ) : Void;
	function setGravityScale( value : Float ) : Void;
	function setPosition( pos : ThreeDeeVector ) : Void;
	function setType( type : RigidBodyType ) : Void;
	function updateTransform() : Void;
	function sleep() : Void;
	function wakeUp() : Void;
	function setAutoSleep( value : Bool ) : Void;
}
