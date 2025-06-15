package game.physics.oimo;

import oimo.common.Vec3;
import game.domain.overworld.location.physics.Types.Vec;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.IShapeConfig;
import util.Assert;
import oimo.dynamics.rigidbody.Shape;

class OimoWrappedShape extends Shape implements IRigidBodyShape {

	public final config : IShapeConfig;

	public function new( config : IShapeConfig ) {
		super( Std.downcast( config, OimoShapeConfig ).config );
		this.config = config;
	}

	public inline function moveLocally( x : Float, y : Float, z : Float ) {
		_localTransform._positionX += x;
		_localTransform._positionY += y;
		_localTransform._positionZ += z;
	}

	public inline function setLocalRotation( x : Float, y : Float, z : Float ) {
		_localTransform.setRotationXyz( new Vec3( x, y, z ) );
	}

	public function getPosition() : Vec {
		var transform = getTransform();
		return {
			x : transform._positionX,
			y : transform._positionY,
			z : transform._positionZ
		};
	}

	public inline function setContactCallbackWrapper( callback : ContactCallbackWrapper ) {
		setContactCallback( callback );
	}

	public function getContactCallbackWrapper() : ContactCallbackWrapper {
		var cb = super.getContactCallback();
		#if debug Assert.isOfType( cb, ContactCallbackWrapper ); #end
		return Std.downcast( cb, ContactCallbackWrapper );
	}

	public inline function setVolume( value : Float ) {
		config.geom.setVolume( value );
		_rigidBody?._shapeModified();
	}

	public inline function getConfig() : IShapeConfig {
		return config;
	}
}
