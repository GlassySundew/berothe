package game.physics.oimo;

import util.Assert;
import oimo.common.Transform;
import game.domain.overworld.location.physics.Types.Quat;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.domain.overworld.location.physics.ITransform;

class OimoTransform implements ITransform {

	public final transform : Transform;

	public inline function new( ?transform : Transform ) {
		this.transform = transform ?? new Transform();
	}

	public inline function getPosition() : ThreeDeeVector {
		return {
			x : transform._positionX,
			y : transform._positionY,
			z : transform._positionZ,
		};
	}

	public inline function setPosition( vec : ThreeDeeVector ) {
		transform._positionX = vec.x;
		transform._positionY = vec.y;
		transform._positionZ = vec.z;
	}

	public inline function getRotation() : ThreeDeeVector {
		return transform.getRotation().toEulerXyz();
	}

	public inline function setRotation( vec : ThreeDeeVector ) {
		transform.setRotationXyz( vec.toOimo() );
	}

	public inline function clone() : ITransform {
		return new OimoTransform( transform.clone() );
	}

	public inline function copyFrom( from : ITransform ) : ITransform {
		#if debug
		Assert.isOfType( from, OimoTransform );
		#end

		transform.copyFrom( Std.downcast( from, OimoTransform ).transform );
		return this;
	}

	public inline function translate( translation : ThreeDeeVector ) {
		transform.translate( translation.toOimo() );
	}
}
