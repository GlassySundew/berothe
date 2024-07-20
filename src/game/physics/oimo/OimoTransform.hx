package game.physics.oimo;

import oimo.common.Transform;
import game.core.rules.overworld.location.physics.Types.Quat;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.ITransform;

class OimoTransform implements ITransform {

	public final transform : Transform;

	public inline function new( transform : Transform ) {
		this.transform = transform;
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

	public inline function getRotation() : Quat {
		return transform.getOrientation();
	}

	public inline function setRotation( vec : ThreeDeeVector ) {
		transform.setRotationXyz( vec.toOimo() );
	}
}
