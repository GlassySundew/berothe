package game.debug.accessor.render;

import util.threeD.Camera.CamController;
import util.threeD.Camera.OrthoController;
import game.net.client.GameClient;
import h3d.col.Bounds;
import util.Settings;
import core.MutableProperty.MutablePropertyBase;

class OrthographicsAccessor extends MutablePropertyBase<Bool> {

	override function get_val() : Bool {
		return super.get_val();
	}

	override function set_val( val : Bool ) : Bool {
		Settings.inst.params.orthographics.val = val;
		if ( val && ( GameClient.inst.cameraProc.cameraController is CamController ) ) {
			GameClient.inst.cameraProc.setOrthoCam();
		}
		if ( !val && ( GameClient.inst.cameraProc.cameraController is OrthoController ) ) {
			GameClient.inst.cameraProc.setPerspCam();
		}
		return super.set_val( val );
	}

	public function new() {
		var value : Bool = Settings.inst.params.orthographics.val;
		super( value );
	}
}
