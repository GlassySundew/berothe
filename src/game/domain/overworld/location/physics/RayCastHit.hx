package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import graphics.ObjectNode3D;

class RayCastHit {

	public inline static function fromOimo( rayCast : oimo.collision.geometry.RayCastHit ) : RayCastHit {
		return new RayCastHit(
			{
				x : rayCast.position.x,
				y : rayCast.position.y,
				z : rayCast.position.z
			},
			{
				x : rayCast.normal.x,
				y : rayCast.normal.y,
				z : rayCast.normal.z
			},
			rayCast.fraction
		);
	}

	public var position : ThreeDeeVector;
	public var normal : ThreeDeeVector;
	public var fraction : Float;

	public inline function new(
		position : ThreeDeeVector,
		normal : ThreeDeeVector,
		fraction : Float
	) {
		this.position = position;
		this.normal = normal;
		this.fraction = fraction;
	}
}
