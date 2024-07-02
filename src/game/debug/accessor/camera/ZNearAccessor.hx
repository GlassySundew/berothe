package game.debug.accessor.camera;

import core.MutableProperty.MutablePropertyBase;

@:access( h3d.scene.CameraController )
class ZNearAccessor extends MutablePropertyBase<Float> {

	override function get_val() {
		return Boot.inst.s3d.camera.zNear;
	}

	override function set_val( v : Float ) {
		return Boot.inst.s3d.camera.zNear = v;
	}

	public function new() {
		super( val );
	}
}
