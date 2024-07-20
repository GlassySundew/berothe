package game.physics.oimo;

import game.data.storage.entity.body.properties.AttackListItemDescription;
import game.core.rules.overworld.location.physics.geom.IBoxGeometry;
import dn.Tweenie;
import hxd.Timer;
import game.core.rules.IUpdatable;

/**
	probably it should "include" `OimoGeometryCastEmitter`, not extend
**/
final class OimoTweenBoxCastEmitter extends OimoGeometryCastEmitter implements IUpdatable {

	// public var enabled = false;
	final tween : Tweenie;
	final type : TType;
	final boxGeom : IBoxGeometry;
	final desc : AttackListItemDescription;

	var tweenSizeX : Float;
	var tweenSizeY : Float;
	var tweenSizeZ : Float;

	public function new(
		desc : AttackListItemDescription,
		physics
	) {
		this.desc = desc;

		var geom = GeometryAbstractFactory.box( desc.sizeX, desc.sizeY, desc.sizeZ );
		super( geom, physics );

		this.boxGeom = geom;
		this.type = switch desc.tweenType {
			case LINEAR: TLinear;
		}

		tween = new Tweenie( Timer.wantedFPS );

		tweenSizeX = desc.sizeX;
		tweenSizeY = desc.sizeY;
		tweenSizeZ = desc.sizeZ;
	}

	public function performCasting() {
		// TODO y and z

		var tweenLocal = tween.createS(
			tweenSizeX,
			desc.endX,
			type,
			desc.duration
		);
		tweenLocal.chainMs(
			desc.sizeX,
			type,
			desc.duration * 1000
		);
		tweenLocal.pixel();
	}

	public inline function update( dt : Float, tmod : Float ) {
		if ( tween.count() == 0 ) return;

		tween.update( tmod );
		emit();
		boxGeom.setSize( { x : tweenSizeX, y : tweenSizeY, z : tweenSizeZ } );
	}
}
