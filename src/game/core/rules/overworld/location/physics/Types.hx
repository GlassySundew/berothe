package game.core.rules.overworld.location.physics;

import dn.Col;
import oimo.common.Vec3;

typedef PrivateVectorType = {
	var x : Float;
	var y : Float;
	var z : Float;
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
}
