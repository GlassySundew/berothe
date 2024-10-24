package game.domain.overworld.location.physics;

import h3d.Quat;
import dn.Col;
import oimo.common.Vec3;

typedef PrivateVectorType = {
	var x : Float;
	var y : Float;
	var z : Float;
}

typedef Quat = {
	> PrivateVectorType,
	var w : Float;
}

abstract ThreeDeeVector( PrivateVectorType ) from PrivateVectorType to PrivateVectorType {

	public static inline function fromColorI( color : Int ) : ThreeDeeVector {
		var color = Col.fromInt( color );
		return { x : color.ri, y : color.gi, z : color.bi };
	}

	public static inline function fromColorF( color : Int ) : ThreeDeeVector {
		var color = Col.fromInt( color );
		return { x : color.rf, y : color.gf, z : color.bf };
	}

	@:from public inline static function fromOimo( vec : Vec3 ) : ThreeDeeVector {
		return { x : vec.x, y : vec.y, z : vec.z };
	}

	public inline static function anglesFromQuat( quat : Quat ) : ThreeDeeVector {
		var quat = new h3d.Quat( quat.x, quat.y, quat.z, quat.w );
		var rotation = quat.toEuler();

		return {
			x : rotation.x,
			y : rotation.y,
			z : rotation.z
		};
	}

	public var x( get, set ) : Float;
	inline function get_x() : Float return this.x;
	inline function set_x( value : Float ) : Float return this.x = value;

	public var y( get, set ) : Float;
	inline function get_y() : Float return this.y;
	inline function set_y( value : Float ) : Float return this.y = value;

	public var z( get, set ) : Float;
	inline function get_z() : Float return this.z;
	inline function set_z( value : Float ) : Float return this.z = value;

	public inline function new( x : Float = 0, y : Float = 0, z : Float = 0 ) {
		this = { x : x, y : y, z : z };
	}

	public inline function setFromVec( vector : ThreeDeeVector ) {
		this.x = vector.x;
		this.y = vector.y;
		this.z = vector.z;
	}

	public inline function sub( subtractive : ThreeDeeVector ) : ThreeDeeVector {
		return {
			x : this.x - subtractive.x,
			y : this.y - subtractive.y,
			z : this.z - subtractive.z
		}
	}

	public inline function add( subtractive : ThreeDeeVector ) : ThreeDeeVector {
		return {
			x : this.x + subtractive.x,
			y : this.y + subtractive.y,
			z : this.z + subtractive.z
		}
	}

	public inline function div( subdiv : Float ) : ThreeDeeVector {
		return {
			x : this.x / subdiv,
			y : this.y / subdiv,
			z : this.z / subdiv
		}
	}

	public inline function clone() : ThreeDeeVector {
		return { x : this.x, y : this.y, z : this.z };
	}

	@:to public inline function toOimo() : Vec3 {
		return new Vec3( this.x, this.y, this.z );
	}
}

enum RigidBodyType {
	DYNAMIC;
	STATIC;
	KINEMATIC;
	TRIGGER;
}
