package game.client.en.comp.view.extensions;

import shader.PaletteSwap;
import game.data.storage.entity.body.view.extensions.ViewPaletteSwapDescription;

class ViewPaletteSwap extends EntityViewExtensionComponentBase {

	public var desc( get, never ) : ViewPaletteSwapDescription;
	function get_desc() : ViewPaletteSwapDescription {
		return Std.downcast( description, ViewPaletteSwapDescription );
	}

	public function new( desc : ViewPaletteSwapDescription ) {
		super( desc );
	}

	override function onViewCompAppeared() {
		super.onViewCompAppeared();
		viewComp.view.then( ( view ) -> {
			var shader = new PaletteSwap( desc.paletteMap );
			for ( mat in view.getGraphics().heapsObject.getMaterials() ) {
				mat.mainPass.addShader( shader );
			}
		} );
	}
}
