package game.debug.accessor.render;

import h3d.col.Bounds;
import util.Settings;
import core.MutableProperty.MutablePropertyBase;

class OrthographicsAccessor extends MutablePropertyBase<Bool> {

	override function get_val() : Bool {
		return super.get_val();
	}

	override function set_val( val : Bool ) : Bool {
		Settings.inst.params.orthographics.val = val;
		if ( val && Boot.inst.s3d.camera.orthoBounds == null ) {
			Boot.inst.s3d.camera.orthoBounds = val ? new Bounds() : null;
		}
		if ( !val ) Boot.inst.s3d.camera.orthoBounds = null;
		return super.set_val( val );
	}

	public function new() {
		var value : Bool = Settings.inst.params.orthographics.val;
		super( value );
	}
}
