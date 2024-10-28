package game.physics.oimo;

import game.physics.oimo.ContactCallbackWrapper;
import game.domain.overworld.location.physics.IRigidBodyShape;
import game.domain.overworld.location.physics.IRigidBody;
import be.Constant;
import oimo.common.Vec3;
import game.physics.oimo.RayCastCallback;
import util.Util;
import dn.M;
import dn.Cooldown;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.domain.overworld.location.physics.IPhysicsEngine;
import game.domain.overworld.location.physics.ITransform;
import game.data.storage.entity.body.properties.AttackListItemVO;
import game.domain.overworld.location.physics.geom.IBoxGeometry;
import dn.Tweenie;
import hxd.Timer;
import game.domain.IUpdatable;

final class AttackTweenBoxCastEmitter implements IUpdatable {

	public inline static final ATTACK_CD_KEY : String = "attack";

	final type : TType;
	final desc : AttackListItemVO;

	final boxGeom : IBoxGeometry;
	final sourceTransform : ITransform;
	final emitTransform : ITransform;
	final tween : Tweenie;
	final cooldown : Cooldown;
	final rigidBody : IRigidBody;
	final shape : IRigidBodyShape;
	final physics : IPhysicsEngine;

	var tweenSizeX : Float;
	var tweenSizeY : Float;
	var tweenSizeZ : Float;

	var tweenCombinator : TweenCombinator;

	var attackRange : Float;

	public function new(
		desc : AttackListItemVO,
		sourceTransform : ITransform,
		physics : IPhysicsEngine
	) {
		this.desc = desc;
		this.sourceTransform = sourceTransform;
		this.physics = physics;
		this.emitTransform = new OimoTransform();
		this.cooldown = new Cooldown( hxd.Timer.wantedFPS );

		var geom = GeometryAbstractFactory.box( desc.sizeX, desc.sizeY, desc.sizeZ );
		var shapeConfig = ShapeConfigFactory.create();
		shapeConfig.setGeometry( geom );

		shape = OimoRigidBodyShape.create( shapeConfig );
		shape.setCollisionGroup( util.Const.G_HITBOX );
		shape.setCollisionMask( util.Const.G_HITBOX );
		shape.setContactCallback( new ContactCallbackWrapper() );

		rigidBody = RigidBodyAbstractFactory.create( shape, TRIGGER );
		rigidBody.setRotationFactor( { x : 0, y : 0, z : 0 } );
		rigidBody.setLinearDamping( { x : 100, y : 100, z : 100 } );
		rigidBody.setGravityScale( 0 );

		this.boxGeom = geom;
		this.type = switch desc.tweenType {
			case LINEAR: TLinear;
		}

		tween = new Tweenie( Timer.wantedFPS );

		tweenSizeX = desc.sizeX;
		tweenSizeY = desc.sizeY;
		tweenSizeZ = desc.sizeZ;
	}

	public inline function setAttackRange( amount : Float ) {
		attackRange = amount;
	}

	public inline function isOnCooldown() : Bool {
		return cooldown.has( '$ATTACK_CD_KEY' );
	}

	public inline function isInAction() : Bool {
		return tween.count() != 0;
	}

	public inline function getCurrentTimelapseRatio() : Float {
		return tweenCombinator.getElapsedProgress() ?? 0;
	}

	public inline function getCallbackContainer() : ContactCallbackWrapper {
		return shape.getContactCallback();
	}

	public function performCasting() {
		// ? y and z maybe because? coz now its only x (forward direction)

		if ( isInAction() ) throw "double cast attacking";
		cooldown.setS(
			'$ATTACK_CD_KEY',
			desc.cooldown + desc.duration * 2
		);
		physics.addRigidBody( rigidBody );

		tweenCombinator = new TweenCombinator();

		var currentTween = tween.createS(
			tweenSizeX,
			attackRange,
			type,
			desc.duration
		);
		tweenCombinator.attachTween( currentTween );
		var currentTween = currentTween.chainMs(
			desc.sizeX - desc.endX + attackRange,
			type,
			desc.duration * 1000
		);
		tweenCombinator.attachTween( currentTween );
		currentTween.onEnd = () -> {
			physics.removeRigidBody( rigidBody );
		};
	}

	public inline function update( dt : Float, tmod : Float ) {
		cooldown.update( tmod );

		if ( tween.count() == 0 ) return;

		tween.update( tmod );
		emitTransform.copyFrom( sourceTransform );

		var diffX = ( tweenSizeX ) * 2;
		var rotatedVector = new ThreeDeeVector(
			desc.offsetX + diffX,
			desc.offsetY,
			desc.offsetZ
		);
		Util.rotateVector( emitTransform.getRotation().z, rotatedVector );

		emitTransform.translate( {
			x : rotatedVector.x,
			y : rotatedVector.y,
			z : rotatedVector.z
		} );

		boxGeom.setSize( { x : tweenSizeX, y : tweenSizeY, z : tweenSizeZ } );

		rigidBody.transform.copyFrom( emitTransform );
		rigidBody.updateTransform();
	}
}

class TweenCombinator {

	final tweens : Array<Tween> = [];

	public function new() {}

	public inline function getElapsedProgress() : Float {
		var collectedProgress = 0.;
		for ( tween in tweens ) {
			collectedProgress += tween.n;
		}
		return collectedProgress / tweens.length;
	}

	public function attachTween( tween : Tween ) {
		tweens.push( tween );
	}
}
