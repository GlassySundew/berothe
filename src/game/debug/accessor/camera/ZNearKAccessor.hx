package game.debug.accessor.camera;

import util.threeD.CameraProcess;
import core.MutableProperty.MutablePropertyBase;

@:access( h3d.scene.CameraController )
class ZNearKAccessor extends MutablePropertyBase<Float> {

	override function get_val() {
		return CameraProcess.zNearK;
	}

	override function set_val( v : Float ) {
		return CameraProcess.zNearK = v;
	}

	public function new() {
		super( val );
	}
}