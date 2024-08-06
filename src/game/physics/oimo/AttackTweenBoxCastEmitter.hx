package game.physics.oimo;

import util.Util;
import dn.M;
import dn.Cooldown;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import game.core.rules.overworld.location.physics.ITransform;
import game.data.storage.entity.body.properties.AttackListItem;
import game.core.rules.overworld.location.physics.geom.IBoxGeometry;
import dn.Tweenie;
import hxd.Timer;
import game.core.rules.IUpdatable;

final class AttackTweenBoxCastEmitter implements IUpdatable {

	public inline static final ATTACK_CD_KEY : String = "attack";

	final type : TType;
	final desc : AttackListItem;

	final boxGeom : IBoxGeometry;
	final sourceTransform : ITransform;
	final emitTransform : ITransform;
	final tween : Tweenie;

	var tweenSizeX : Float;
	var tweenSizeY : Float;
	var tweenSizeZ : Float;

	var tweenCombinator : TweenCombinator;

	final emitter : OimoGeometryCastEmitter;

	final cooldown : Cooldown;

	public function new(
		desc : AttackListItem,
		sourceTransform : ITransform,
		physics : IPhysicsEngine
	) {
		this.desc = desc;
		this.sourceTransform = sourceTransform;
		this.emitTransform = new OimoTransform();
		this.cooldown = new Cooldown( hxd.Timer.wantedFPS );

		var geom = GeometryAbstractFactory.box( desc.sizeX, desc.sizeY, desc.sizeZ );
		emitter = new OimoGeometryCastEmitter( geom, emitTransform, physics );

		this.boxGeom = geom;
		this.type = switch desc.tweenType {
			case LINEAR: TLinear;
		}

		tween = new Tweenie( Timer.wantedFPS );

		tweenSizeX = desc.sizeX;
		tweenSizeY = desc.sizeY;
		tweenSizeZ = desc.sizeZ;
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

	public function performCasting() {
		// TODO y and z maybe(?) because now its only x (forward direction)

		cooldown.setS( '$ATTACK_CD_KEY', desc.cooldown + desc.duration * 2 );

		tweenCombinator = new TweenCombinator();
		var currentTween = tween.createS(
			tweenSizeX,
			desc.endX,
			type,
			desc.duration
		);
		tweenCombinator.attachTween( currentTween );
		var currentTween = currentTween.chainMs(
			desc.sizeX,
			type,
			desc.duration * 1000
		);
		tweenCombinator.attachTween( currentTween );

		// tweenLocal.pixel();
	}

	public inline function update( dt : Float, tmod : Float ) {
		cooldown.update( tmod );

		if ( tween.count() == 0 ) return;

		tween.update( tmod );
		emitTransform.copyFrom( sourceTransform );

		var rotatedVector = new ThreeDeeVector(
			desc.offsetX + ( tweenSizeX - desc.sizeX ) * 2,
			desc.offsetY + ( tweenSizeY - desc.sizeY ) * 2,
			desc.offsetZ
		);
		Util.rotateVector( emitTransform.getRotation().z, rotatedVector );

		emitTransform.translate( {
			x : rotatedVector.x,
			y : rotatedVector.y,
			z : rotatedVector.z // desc.offsetZ
		} );

		boxGeom.setSize( { x : tweenSizeX, y : tweenSizeY, z : tweenSizeZ } );
		emitter.emit();
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
