package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.Vec;
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

	public var position : Vec;
	public var normal : Vec;
	public var fraction : Float;

	public inline function new(
		position : Vec,
		normal : Vec,
		fraction : Float
	) {
		this.position = position;
		this.normal = normal;
		this.fraction = fraction;
	}
}
