package game.client.debug.accessor.camera;

import core.MutableProperty.MutablePropertyBase;

@:access( h3d.scene.CameraController )
class ZFarAccessor extends MutablePropertyBase<Float> {

	override function get_val() {
		return Boot.inst.s3d.camera.zFar;
	}

	override function set_val( v : Float ) {
		return Boot.inst.s3d.camera.zFar = v;
	}

	public function new() {
		super( val );
	}
}