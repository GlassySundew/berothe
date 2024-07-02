package game.debug.accessor.camera;

import util.threeD.CameraProcess;
import core.MutableProperty.MutablePropertyBase;

@:access( h3d.scene.CameraController )
class ZFarKAccessor extends MutablePropertyBase<Float> {

	override function get_val() {
		return CameraProcess.zFarK;
	}

	override function set_val( v : Float ) {
		return CameraProcess.zFarK = v;
	}
	
	public function new() {
		super( val );
	}
}
