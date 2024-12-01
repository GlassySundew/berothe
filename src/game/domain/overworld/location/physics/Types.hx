package game.domain.overworld.location.physics;

import h3d.Vector;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.combat.EntityDamageService;
import game.physics.oimo.EntityRigidBodyProps;
import oimo.dynamics.Contact;
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

	@:from public inline static function fromh3d( vec : Vector ) : ThreeDeeVector {
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

	public inline function set( x : Float, y : Float, z : Float ) {
		this.x = x;
		this.y = y;
		this.z = z;
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

	public inline function lengthSq() {
		return x * x + y * y + z * z;
	}

	public inline function length() {
		return hxd.Math.sqrt( lengthSq() );
	}

	public inline function distance( v : ThreeDeeVector ) {
		return Math.sqrt( distanceSq( v ) );
	}

	public inline function distanceSq( v : ThreeDeeVector ) {
		var dx = v.x - x;
		var dy = v.y - y;
		var dz = v.z - z;
		return dx * dx + dy * dy + dz * dz;
	}

	public inline function cross( v : ThreeDeeVector ) {
		// note : cross product is left-handed
		return new ThreeDeeVector( y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x );
	}

	public inline function normalize() {
		var k = lengthSq();
		if ( k < hxd.Math.EPSILON2 ) k = 0 else k = hxd.Math.invSqrt( k );
		x *= k;
		y *= k;
		z *= k;
	}

	public inline function dot( v : ThreeDeeVector ) {
		return x * v.x + y * v.y + z * v.z;
	}

	public inline function scale( f : Float ) {
		/*
			The scale of a vector represents its length and thus
			only x/y/z should be affected by scaling
		 */
		x *= f;
		y *= f;
		z *= f;
	}

	public inline function scaled( v : Float ) {
		// see scale
		return new ThreeDeeVector( x * v, y * v, z * v );
	}

	public inline function negate() {
		x = -x;
		y = -y;
		z = -z;
	}

	public inline function getForwardZ() : ThreeDeeVector {
		var forwardX = Math.cos( z );
		var forwardY = Math.sin( z );
		return new ThreeDeeVector( forwardX, forwardY, 0 );
	}

	public inline function normalized() {
		var k = lengthSq();
		if ( k < hxd.Math.EPSILON2 ) k = 0 else k = hxd.Math.invSqrt( k );
		return new ThreeDeeVector( x * k, y * k, z * k );
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

class EntityCollisionsService {

	#if !debug inline #end
	public static function unwrapContact(
		contact : Contact,
		cb : ( entity1 : OverworldEntity, entity2 : OverworldEntity ) -> Void
	) {
		var maybeEntity1 = Std.downcast( contact._b1?.userData, EntityRigidBodyProps )?.entity;
		var maybeEntity2 = Std.downcast( contact._b2?.userData, EntityRigidBodyProps )?.entity;

		if ( maybeEntity1 != null || maybeEntity2 != null ) cb( maybeEntity1, maybeEntity2 );
	}
}
