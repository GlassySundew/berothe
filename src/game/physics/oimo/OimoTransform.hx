package game.physics.oimo;

import util.Assert;
import oimo.common.Transform;
import game.domain.overworld.location.physics.Types.Quat;
import game.domain.overworld.location.physics.Types.Vec;
import game.domain.overworld.location.physics.ITransform;

class OimoTransform implements ITransform {

	public final transform : Transform;

	public inline function new( ?transform : Transform ) {
		this.transform = transform ?? new Transform();
	}

	public inline function add( vec : Vec ) {
		transform.translate( vec.toOimo() );
	}

	public inline function getPosition() : Vec {
		return {
			x : transform._positionX,
			y : transform._positionY,
			z : transform._positionZ,
		};
	}

	public inline function setPosition( vec : Vec ) {
		transform._positionX = vec.x;
		transform._positionY = vec.y;
		transform._positionZ = vec.z;
	}

	public inline function getRotation() : Vec {
		return transform.getRotation().toEulerXyz();
	}

	public inline function setRotation( vec : Vec ) {
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

	public inline function translate( translation : Vec ) {
		transform.translate( translation.toOimo() );
	}
}
