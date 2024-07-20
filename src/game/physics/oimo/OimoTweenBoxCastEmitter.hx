package game.physics.oimo;

import hxd.Timer;
import dn.Tweenie;

class OimoTweenBoxCastEmitter extends OimoGeometryCastEmitter {

	public var enabled = false;

	final tween : Tweenie;

	final duration : Float;
	final cooldown : Float;

	public function new( duration : Float, cooldown : Float, geom, physics ) {
		super( geom, physics );
		this.duration = duration;
		this.cooldown = cooldown;

		tween = new Tweenie( Timer.wantedFPS );
	}

	
	
	// override function update( dt : Float, tmod : Float ) {
	// 	tween.update( dt );
	// 	super.update( dt, tmod );
	// }
}
