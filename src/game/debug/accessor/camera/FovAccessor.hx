package game.debug.accessor.camera;

import game.net.client.GameClient;
import core.MutableProperty.MutablePropertyBase;

@:access( h3d.scene.CameraController )
class FovAccessor extends MutablePropertyBase<Float> {

	override function get_val() {
		return GameClient.inst.cameraProc.cameraController.targetOffset.w;
	}

	override function set_val( v : Float ) {
		return GameClient.inst.cameraProc.cameraController.targetOffset.w = v;
	}

	public function new() {
		super( val );
	}
}
