package game.client.en.comp.view.extensions;

import h3d.shader.ColorAdd;
import h3d.shader.ColorMatrix;
import game.data.storage.entity.body.view.extensions.ViewColorRandomShiftDescription;

class ViewColorRandomShift extends EntityViewExtensionComponentBase {

	public var desc( get, never ) : ViewColorRandomShiftDescription;
	function get_desc() : ViewColorRandomShiftDescription {
		return Std.downcast( description, ViewColorRandomShiftDescription );
	}

	public function new( desc : ViewColorRandomShiftDescription ) {
		super( desc );
	}

	override function onViewCompAppeared() {
		super.onViewCompAppeared();
		viewComp.view.then( ( view ) -> {
			var shader = new ColorAdd( Std.int( hxd.Math.random( 2 * desc.radius ) - desc.radius ) );
			for ( mat in view.getGraphics().heapsObject.getMaterials() ) {
				mat.mainPass.addShader( shader );
			}
		} );
	}
}
