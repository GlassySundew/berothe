package phys;

import oimo.common.MathUtil;
import oimo.common.Setting;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.m.IVec3;
import oimo.m.M;

@:build( oimo.m.B.bu() )
class CustomRigidBody extends RigidBody {

	public var isPositionSnapped : Bool = false;

	public var fractPos : IVec3;

	public function new( config : RigidBodyConfig ) {
		super( config );
		M.vec3_zero( fractPos );
	}

	public override function _integrate( dt : Float ) : Void {
		switch ( _type ) {
			case RigidBodyType.DYNAMIC, RigidBodyType._KINEMATIC:
				var translation : IVec3;
				var rotation : IVec3;
				M.vec3_scale( translation, _vel, dt );
				M.vec3_scale( rotation, _angVel, dt );

				var translationLengthSq : Float = M.vec3_dot( translation, translation );
				var rotationLengthSq : Float = M.vec3_dot( rotation, rotation );

				if ( translationLengthSq == 0 && rotationLengthSq == 0 ) {
					return; // no need of integration
				}

				// limit linear velocity
				if ( translationLengthSq > Setting.maxTranslationPerStep * Setting.maxTranslationPerStep ) {
					var l : Float = Setting.maxTranslationPerStep / MathUtil.sqrt( translationLengthSq );
					M.vec3_scale( _vel, _vel, l );
					M.vec3_scale( translation, translation, l );
				}

				// limit angular velocity
				if ( rotationLengthSq > Setting.maxRotationPerStep * Setting.maxRotationPerStep ) {
					var l : Float = Setting.maxRotationPerStep / MathUtil.sqrt( rotationLengthSq );
					M.vec3_scale( _angVel, _angVel, l );
					M.vec3_scale( rotation, rotation, l );
				}

				// update the transform
				if ( isPositionSnapped ) {
					M.vec3_add( fractPos, fractPos, translation );
					if ( Math.abs( fractPosX ) > 1 ) {
						_transform._positionX += Std.int( fractPosX );
						fractPosX %= 1;
					}
					if ( Math.abs( fractPosY ) > 1 ) {
						_transform._positionY += Std.int( fractPosY );
						fractPosY %= 1;
					}
					if ( Math.abs( fractPosZ ) > 1 ) {
						_transform._positionZ += Std.int( fractPosZ );
						fractPosZ %= 1;
					}
				} else M.call( _applyTranslation( translation ) );

				M.call( _applyRotation( rotation ) );

			case RigidBodyType._STATIC:
				M.vec3_zero( _vel );
				M.vec3_zero( _angVel );
				M.vec3_zero( _pseudoVel );
				M.vec3_zero( _angPseudoVel );
		}
	}
}
